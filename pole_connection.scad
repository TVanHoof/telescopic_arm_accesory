// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Thomas Van Hoof

use <indexed_joint.scad>

// handle to connect mounting_base to accessory_mount with 2 indexed joints
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

//tube that should go inside of the telescopic arm
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

// One printed button: cylindrical stem, chamfered shoulder and a rounded tip.
// Built along +Z from the attachment plane so it can be rotated onto ±Y.
module latch_button(length, stem_d, tip_d, chamfer_length, dome_height) {
  stem_r = stem_d / 2;
  tip_r = tip_d / 2;
  stem_len = length - chamfer_length - dome_height;

  cylinder(h = stem_len, r = stem_r);
  translate([0, 0, stem_len])
    cylinder(h = chamfer_length, r1 = stem_r, r2 = tip_r);
  translate([0, 0, length - dome_height])
    scale([1, 1, dome_height / tip_r])
      sphere(r = tip_r, $fn = 32);
}

// Separate printed spring insert. Two angled arms are joined near the handle;
// their buttons pass through the guide hole in mounting_base and lock into the
// holes of the outer telescopic tube. Squeezing the buttons flexes the arms so
// the insert can slide.
module latch_insert(
    tube_outer_d = 28.5,
    tube_thickness = 3,
    guide_hole_d = 6,
    button_z = 50,
    bridge_z = 95,
    button_protrusion = 4,
    button_clearance = 0.5,
    arm_width = 8,
    arm_thickness = 2,
    arm_top_y = 4,
    chamfer_length = 0.5,
    dome_height = 1
) {
  outer_r = tube_outer_d / 2;
  inner_r = outer_r - tube_thickness;
  overlap = 0.5;
  button_start_y = inner_r - overlap;
  button_len = outer_r + button_protrusion - button_start_y;
  stem_d = guide_hole_d - button_clearance;
  tip_d = stem_d - 0.5;
  arm_tip_y = inner_r - arm_thickness / 2;

  // bridge joining the two arms near the handle end of the tube
  translate([0, 0, bridge_z])
    cube([arm_width, 2 * arm_top_y + arm_thickness, arm_thickness], center = true);

  for (side = [-1, 1]) {
    hull() {
      translate([0, side * arm_top_y, bridge_z])
        cube([arm_width, arm_thickness, arm_thickness], center = true);
      translate([0, side * arm_tip_y, button_z])
        cube([arm_width, arm_thickness, arm_thickness], center = true);
    }

    translate([0, side * button_start_y, button_z])
      rotate([side == 1 ? -90 : 90, 0, 0])
        latch_button(
          length = button_len,
          stem_d = stem_d,
          tip_d = tip_d,
          chamfer_length = chamfer_length,
          dome_height = dome_height
        );
  }
}

// connection of the arm to the rest
module pole_connection(with_insert = true) {
  base_diam = 28.5;
  h_connection = 100;
  wall = 3;
  hole_diam = 6;

  mounting_base(height = h_connection,
         outer_diam = base_diam,
         thickness = wall,
         hole_diam = hole_diam,
         center = false);
  translate([0, 0, h_connection])
    handle(base_diam = base_diam,
        flange_radius = 22,
        bolt_diam = 8);

  if(with_insert)
    latch_insert(
        tube_outer_d = base_diam,
        tube_thickness = wall,
        guide_hole_d = hole_diam,
        button_z = h_connection / 2,
        bridge_z = h_connection - 5
        );
}

