use <pole_connection.scad>
use <base_mount.scad>
use <accesory_mount.scad>

$fn=500;

pole_connection();
translate([0, 24, 150])
  rotate([90,0,0])
    base_mount();
translate([0, -24, 150])
  rotate([-90,180,0])
    base_mount();

translate([0,0,200])
  accessory_mount();

//explode
//{
//translate([0,100,0])
//  pole_connection();
//
//translate([0,150,0])
//  base_mount();
//
//translate([0,300,0])
//  accessory_mount();
//}
