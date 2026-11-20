// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Thomas Van Hoof

use <pole_connection.scad>
use <base_mount.scad>
use <accesory_mount.scad>

use <accesories/clamp.scad>

// ["assembly", "exploded", "all"]
view = "all";

$fn= $preview? 32: 500;

module base(){
  pole_connection();
  translate([0, 24, 150])
    rotate([90,0,0])
    base_mount();
  translate([0, -24, 150])
    rotate([-90,180,0])
    base_mount();

  translate([0,0,200])
    accessory_mount();
}

if(view == "assembly" || view == "all"){
  base();

  for (x = [-1, 1])
    translate([x * 50, 0, 230]) clamp();

  translate([0,0,260]) clamp_adapter();
}

if (view == "exploded" || view == "all")
{
  offset = view == "all" ? 100 : 0;
translate([0,offset,0]) pole_connection();
translate([0,offset+50,0]) base_mount();
translate([0,offset+200,0]) accessory_mount();
translate([0,offset+300,0]) clamp();
translate([0,offset+375,0]) clamp_adapter();
}
