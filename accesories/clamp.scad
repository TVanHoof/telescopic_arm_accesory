use <../accesory_base.scad>

module clamp() {
  h = 20;
  w = 150;
  l = 100;

  //base plate
  translate([0,0,h/2])
  accesory_base();
//  translate([0, 0, h/2])
//  difference(){
//    cube([w,l,h], center = true);
//
//    for (x = [-1,1], y = [-1,1]) {
//      translate([
//          x * (w/2 - 9),
//          y * (l/2 - 9),
//          0
//      ]){
//        cylinder(
//            h = h + 1,
//            d = 5,
//            center = true
//            );
//        translate([0,0,h/2])
//          cylinder(h = h * 0.75, r = 8, center = true, $fn = 6);
//      }
//    }
//    cylinder(h = h + 1, r = 6, center = true);
//
//    translate([0,0,h / 2])
//      cylinder(h = h + 1, r = 10, center = true, $fn=6);
//  }

  //mounting mechanism
  for (x = [-1,1]){
    s = 50;
    translate([x * (w - s)/2,0,h + s/2]){
      difference(){
      cube([s, s, s], center = true);
      rotate([0,90,0])
      cylinder(d = s * 0.75, h = s + 1, center = true);
      }
    }
  }
}
