// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Thomas Van Hoof

use <dovetail_joint.scad>
use <accesory_base.scad>

//generic module which can be mounted on top of 2 base mounts
//on top there are several options to be mounted
//there are 4 minor holes in the corners,
//a central hole for an M6 and 2 dovetail joints on top
module accessory_mount(
  width = 150,                  //width (along x-axis)
  length = 100,                 //length (along y-axis)
  thickness = 30,               //thickness (along z-axis)
  hole_diameter = 5,            //diameter of holes in corner
  dovetail_offset = 40,         //lateral distance of the slots from the center
  dovetail_height = 8,          //height of dovetail slot
  dovetail_root_width = 26,     //root width of the dovetail slot
  dovetail_tip_width = 34,      //tip width of the dovetail slot
  dovetail_clearance = 0.3      //clearance for dovetail slot
) {
  translate([0,0,thickness / 2]){
    difference() {
      rotate([180,0,0])
        accesory_base();

      // dovetail slots in the bottom face (mating plane = z = -thickness / 2)
      for (x = [-1, 1]){
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
        translate([x * length / 2, 0, thickness / 2])
          rotate([180,0,90])
            dovetail_joint(
              type = "female",
              length = length / 2 + 0.01);
      }
    }
  }
}

