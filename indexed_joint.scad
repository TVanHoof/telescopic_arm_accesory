// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Thomas Van Hoof

// ============================================================================
//  Indexed joint - ONE module for both halves.
//
//  indexed_joint_half("male")   = flange with a 12-sided boss and 24 radial
//                                 teeth standing on its mating face.
//  indexed_joint_half("female") = matching flange with a 12-sided socket and
//                                 24 radial grooves cut into its mating face.
//
//  Canonical frame (shared by both halves):
//    Z = joint axis. The flange base sits at z = 0; its mating face is the
//        upper surface (z = flange_thickness, 0.05 mm less for the female).
//        Male features grow upwards from that face, female features are cut
//        downwards into it.
//    X/Y = plane of the flange, centred on the bolt hole.
//
//  Assembly: flip one half 180 degrees and bring the two mating faces
//  together. The male boss enters the female socket, the male teeth engage
//  the female grooves, and the two central holes line up for an M8 bolt.
//  The 12-sided boss/socket allows rotation in 30 degree steps; the teeth
//  and grooves themselves are spaced every 15 degrees.
//
//  Fits: socket radius is 0.25 mm larger than the boss radius, female
//  grooves are 0.15 mm wider and 0.01 mm deeper than the male teeth, and
//  the female flange is 0.05 mm thinner than the male one.
// ============================================================================
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


