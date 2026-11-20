use <../dovetail_joint.scad>

module clamp(
  slit_w = 2,
  ear_width = 20,
  ear_height = 20) {
  s = 50;
  height = 60;
  bore_d = s * 0.75;
  screw_d = 8;              // M8 thumb screws
  screw_hole_d = screw_d + 0.5;
  screw_x = [-12, 12];      // two screws per collar, spaced along X
  nut_AF = 13;              // M8 hex nut across flats
  nut_t = 6.5;              // M8 nut thickness
  washer_d = 16;
  washer_depth = 1.5;
  translate([0,0,height/2])
  difference(){
    union(){
      // main mass
      cube([s, s, height], center = true);
      // ears to clamp
      translate([0,0,height/2 + ear_height / 2])
        cube([s,2* ear_width + slit_w, ear_height], center = true);
    }
    // central hole to actually clamp
    rotate([0,90,0])
      cylinder(d = bore_d, h = s + 1, center = true);
    // split on top
    translate([0,0,height/2])
      cube([s+ 1,slit_w,s], center = true);

    translate([0,0,bore_d/2 - 2])
      rotate([0,90,0])
        cylinder(d = slit_w + 3, h = s+1, center = true);

    for (x = [-s/4, s/4]){
      translate([x, 0, height/2 + ear_height / 2]){
        rotate([90,0,0]){
          // screw hole
          cylinder(
              h = 2 * (slit_w / 2 + ear_width + 2),
              d = 8.5,
              center = true
            );

            // captive nut on the -Y ear
            translate([
                  0,
                  0,
                  slit_w/2 + ear_width - washer_depth])
              cylinder(
                h = nut_t + 0.5,
                r = nut_AF / sqrt(3),
                center = true,
                $fn = 6
              );

            // washer on the +Y ear
            translate([
                  0,
                  0,
                  -slit_w/2 - ear_width + washer_depth/2])
              cylinder(
                h = washer_depth + 0.2,
                d = washer_d,
                center = true
              );
          }
        }
    }
  }
  rotate([0,180,90])
  dovetail_joint(
    type = "male",
    length = s);
}

// Split adapter sleeve for mounting a smaller shaft in the 37.5 mm bore.
// Print one per shaft diameter; its slit lines up with the clamp slits.
module clamp_adapter(
  shaft_d = 30,
  outer_d = 37.2,
  length = 150,
  slit_w = 2,
  set_screw = true,
  set_screw_d = 4,
  boss_d = 12,
  boss_length = 8,
  screw_pos = 0          // keep this in the 50 mm gap between the collars
) {
  ro = outer_d / 2;
  ri = shaft_d / 2;

  difference(){
    union(){
      rotate([0,90,0])
        cylinder(d = outer_d, h = length, center = true);

      if (set_screw) {
        // radial boss for an M4 thumb screw that locks the shaft to the sleeve
        translate([screw_pos, ro + boss_length/2 - 0.5, 0])
          rotate([90,0,0])
            cylinder(d = boss_d, h = boss_length + 1, center = true);
      }
    }

    // shaft bore
    rotate([0,90,0])
      cylinder(d = shaft_d, h = length + 2, center = true);

    // slit aligned with the clamp slit; dipped 1 mm into the bore so the
    // slot fully breaks through instead of meeting the bore at a tangent
    translate([0, 0, (ri + ro)/2])
      cube([length + 2, slit_w, ro - ri + 2], center = true);

    if (set_screw) {
      // thumb screw hole, from the boss into the shaft
      translate([screw_pos, (ro + boss_length)/2, 0])
        rotate([90,0,0])
          cylinder(
              h = ro + boss_length + 2,
              d = set_screw_d + 0.5,
              center = true
          );
    }
  }
}

// Example:
// clamp_adapter(shaft_d = 30);

