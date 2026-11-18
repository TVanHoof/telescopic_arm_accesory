// ============================================================================
//  Dovetail slide joint - ONE module for both halves.
//
//  Canonical frame (shared by both halves):
//    X = across the joint      Y = along the joint (slide direction)
//    Z = out of the mating plane, z = 0 IS the mating plane
//    male   : land below z=0, rib occupies z = 0 .. height
//    female : land above z=0, slot occupies z = 0 .. height + clearance
//  Both halves share the same frame, so they mate by putting the two
//  mating planes together (no mirroring needed).
// ============================================================================
module dovetail_joint(
    type             = "male",   // "male" = rib (union it), "female" = slot (subtract it)
    length           = 40,       // length along Y
    height           = 8,        // rib height / slot depth
    root_width       = 26,       // male width at the root (at the mating plane)
    tip_width        = 34,       // male width at the tip (undercut -> locks the female)
    clearance        = 0.3       // per side gap of the female slot
) {
  // cross section of the rib, x = lateral, y = height
  module male_profile() {
    polygon([
      [-root_width / 2, 0],
      [ root_width / 2, 0],
      [ tip_width  / 2, height],
      [-tip_width  / 2, height]
    ]);
  }

  if (type == "male") {
    // rib, grows up out of the mating plane
    rotate([90, 0, 0])
      linear_extrude(height = length, center = true)
        male_profile();
  }
  else {
    // slot, cut into the mating plane, male profile grown by the clearance
    rotate([90, 0, 0])
      linear_extrude(height = length, center = true)
        offset(delta = clearance) male_profile();
  }
}


