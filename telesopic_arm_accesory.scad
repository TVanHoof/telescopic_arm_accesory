$fn=500;

module mounting_base(height, outer_diam, thickness, hole_diam, center = false) {
  translate([0,0, center ? 0 : height / 2]){
    difference(){
      cylinder(h = height, d = outer_diam, center = true);
      cylinder(h = height + 1, d = outer_diam - thickness * 2, center = true);
      rotate([90,0,0]){
        cylinder(h = outer_diam+10, d = hole_diam, center = true);
      }
    }
  }
}

module handle(base_diam, flange_radius, bolt_diam) {
  difference(){
    union(){
      intersection(){
        hull() {
          translate([0, 0, 0])
            cylinder(h = 1, d = base_diam, center = true);

          translate([0, 0, 50])
            linear_extrude(height = 1)
              square([2 * flange_radius, base_diam], center = true);
        }
        cube([200,base_diam,200], center = true);
      }

      translate([0,0,50])
        rotate([90,0,0])
          cylinder(h = base_diam, r = 22, center = true);

      translate([0,-base_diam / 2 + 7,50])
        rotate([90,0,0])
          indexed_joint_half("male");

      translate([0,base_diam / 2 - 7,50])
        rotate([-90,0,0])
          indexed_joint_half("male");
    }

    translate([0,0,50])
      rotate([90,0,0])
        cylinder(h = 100, d = bolt_diam, center = true);
  }
}

module indexed_joint_half(type = "male") {

  // Joint parameters
  joint_sides = 12;
  joint_radius = 14;
  joint_depth = 6;
  clearance = 0.25;

  flange_radius = 22;
  flange_thickness = 8;
  flange_clearance = 0.05;      // female flange is this much thinner than the male one

  bolt_diameter = 8;

  // Radial groove parameters
  groove_count = 24;
  groove_width = 1.2;
  groove_depth = 0.8;
  groove_inner_radius = 15;
  groove_outer_radius = 21;
  groove_clearance = 0.15;

  // Creates radial trapezoidal teeth
  module radial_teeth(
      count,
      inner_radius,
      outer_radius,
      width,
      height
      ) {

    for (i = [0 : count - 1]) {

      rotate([0,0,i * 360 / count])

        linear_extrude(height = height)

        polygon([
            [inner_radius, -width * 0.35],
            [outer_radius, -width * 0.5],
            [outer_radius, width * 0.5],
            [inner_radius, width * 0.35]
        ]);
    }
  }

  difference() {

    union() {

      // Main flange
      cylinder(
          h = type == "female" ? flange_thickness - flange_clearance : flange_thickness,
          r = flange_radius
          );

      // Male polygonal boss
      if (type == "male") {
        translate([0,0,flange_thickness])
          cylinder(
              h = joint_depth,
              r = joint_radius,
              $fn = joint_sides
              );
      }

      // Radial teeth on male mating face
      if (type == "male") {
        translate([0,0,flange_thickness])
          radial_teeth(
              groove_count,
              groove_inner_radius,
              groove_outer_radius,
              groove_width,
              groove_depth
              );
      }
    }

    // Female polygonal socket
    if (type == "female") {
      translate([
          0,
          0,
          flange_thickness - joint_depth - 0.01
      ])
        cylinder(
            h = joint_depth + 0.02,
            r = joint_radius + clearance,
            $fn = joint_sides
            );
    }

    // Radial grooves on female mating face
    if (type == "female") {
      translate([
          0,
          0,
          flange_thickness - groove_depth
      ])
        radial_teeth(
            groove_count,
            groove_inner_radius,
            groove_outer_radius,
            groove_width + groove_clearance,
            groove_depth + 0.01
            );
    }

    // Central bolt hole
    translate([0,0,-1])
      cylinder(
          h = flange_thickness + joint_depth + 2,
          d = bolt_diameter
          );
  }
}


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


// Generic accessory interface
module accessory_plate(
  width = 150,
  length = 100,
  thickness = 20,
  hole_diameter = 5,
  dovetail_offset = 40,          // lateral distance of the slots from the centre
  dovetail_height = 8,
  dovetail_root_width = 26,
  dovetail_tip_width = 34,
  dovetail_clearance = 0.3
) {
  translate([0,0,thickness / 2]){
    difference() {
      cube([width, length, thickness], center = true);

      for (x = [-1,1], y = [-1,1]) {
        translate([
          x * (width/2 - 8),
          y * (length/2 - 8),
          0
        ])
          cylinder(
            h = thickness + 1,
            d = hole_diameter,
            center = true
          );
      }

      cylinder(h = thickness + 1, r = 6, center = true);

      translate([0,0,-thickness / 2])
        cylinder(h = thickness, r = 10, center = true, $fn=6);

      // dovetail slots in the bottom face (mating plane = z = -thickness / 2)
      for (x = [-1, 1])
        translate([
          x * dovetail_offset,
          0,
          -thickness / 2
        ])
          dovetail_joint(
            type       = "female",
            length     = length + 1,
            height     = dovetail_height,
            root_width = dovetail_root_width,
            tip_width  = dovetail_tip_width,
            clearance  = dovetail_clearance
          );
    }
  }
}

module accessory_mount() {
  accessory_plate();
}

module pole_piece() {
  base_diam = 30;
  h_connection = 100;
  mounting_base(height = h_connection,
         outer_diam = base_diam,
         thickness = 5,
         hole_diam = 6,
         center = false);
  translate([0, 0, h_connection])
    handle(base_diam = base_diam,
        flange_radius = 22,
        bolt_diam = 8);
}

module mounting_piece(
  bracket_width  = 120,        // lateral size of the bracket
  bracket_depth  = 8,          // size along the arm axis (must stay clear of the male flange)
  bracket_height = 50,         // height above the hub axis
  hub_bore       = 43,         // bore that saddles the hub flange
  dovetail_offset = 40,        // lateral distance of the ribs from the centre
  dovetail_length = 24,        // rib length along the arm axis
  dovetail_height = 8,
  dovetail_root_width = 26,
  dovetail_tip_width = 34,
  dovetail_clearance = 0.3
) {
  indexed_joint_half("female");

  // bracket that saddles the hub and rises above it
  difference(){
    linear_extrude(height = bracket_depth)
      translate([0, bracket_height / 2, 0])
        square([bracket_width, bracket_height], center = true);
    translate([0, 0, bracket_depth / 2])
      cylinder(h = bracket_depth + 2, d = hub_bore, center = true);
  }

  // male dovetail ribs on top of the bracket, running inwards over the hub
  for (x = [-1, 1])
    translate([x * dovetail_offset, bracket_height, bracket_depth / 2])
      rotate([-90, 0, 0])
        dovetail_joint(
          type       = "male",
          length     = dovetail_length,
          height     = dovetail_height,
          root_width = dovetail_root_width,
          tip_width  = dovetail_tip_width,
          clearance  = dovetail_clearance
        );
}

pole_piece();
translate([0, 24, 150])
  rotate([90,0,0])
    mounting_piece();
translate([0, -24, 150])
  rotate([-90,180,0])
    mounting_piece();

translate([0,0,200])
  accessory_mount();
