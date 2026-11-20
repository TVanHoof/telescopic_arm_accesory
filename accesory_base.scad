// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Thomas Van Hoof

//generic module which can be extended by other modules
//in order to fixate external accesories
//already present: a central mass with a hole in each corner
//and a central hole to fit an M6
module accesory_base(
  width = 150,                //width (along x-axis)
  length = 100,               //length (along y-axis)
  thickness = 30,             //thickness (along z-axis)
  hole_diameter = 5,          //diameter of holes in corner
  hole_offset_from_edge = 9   //offset of hole from the edge
  ){
  difference(){
    cube([width, length, thickness], center = true);
    for (x = [-1,1], y = [-1,1]) {
      translate([
          x * (width/2 - hole_offset_from_edge),
          y * (length/2 - hole_offset_from_edge),
          0
      ])
        cylinder(
            h = thickness + 1,
            d = hole_diameter,
            center = true
            );
    }

    cylinder(h = thickness + 1, d = 6, center = true);

    translate([0,0,thickness / 2])
      cylinder(h = thickness, d = 10, center = true, $fn=6);
  }
}
