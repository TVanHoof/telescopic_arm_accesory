// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Thomas Van Hoof

use <dovetail_joint.scad>
use <indexed_joint.scad>

//connection between pole_connection and accesory_mount
//allowing different angles
module base_mount(
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


