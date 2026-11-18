use <dovetail_joint.scad>
use <accesory_base.scad>

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
      rotate([180,0,0])
        accesory_base();

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

