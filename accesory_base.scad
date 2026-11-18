module accesory_base(
  width = 150,
  length = 100,
  thickness = 20,
  hole_diameter = 5
  ){
  difference(){
    cube([width, length, thickness], center = true);
    for (x = [-1,1], y = [-1,1]) {
      translate([
          x * (width/2 - 9),
          y * (length/2 - 9),
          0
      ])
        cylinder(
            h = thickness + 1,
            d = hole_diameter,
            center = true
            );
    }

    cylinder(h = thickness + 1, r = 6, center = true);

    translate([0,0,thickness / 2])
      cylinder(h = thickness, r = 10, center = true, $fn=6);
  }
}
