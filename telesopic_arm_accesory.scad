use <pole_connection.scad>
use <base_mount.scad>
use <accesory_mount.scad>

use <accesories/clamp.scad>

$fn=500;

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

base();

for (x = [-1, 1])
  translate([x * 50, 0, 230])
    clamp();

translate([0,0,260])
  clamp_adapter();

//explode
{
translate([0,100,0])
  pole_connection();

translate([0,150,0])
  base_mount();

translate([0,300,0])
  accessory_mount();

translate([0,400,0])
  clamp();
}
