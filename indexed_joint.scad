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


