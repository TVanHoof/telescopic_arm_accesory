use <dovetail_joint.scad>

module accessory_mount(
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

