use <indexed_joint.scad>

module handle(base_diam, flange_radius, bolt_diam) {
  difference(){
    union(){
      intersection(){
        hull() {
          translate([0, 0, 0])
            cylinder(h = 1, d = base_diam, center = true);

          translate([0, 0, 50])
            linear_extrude(height = 1)
              square([2 * flange_radius, base_diam], center = true);
        }
        cube([200,base_diam,200], center = true);
      }

      translate([0,0,50])
        rotate([90,0,0])
          cylinder(h = base_diam, r = 22, center = true);

      translate([0,-base_diam / 2 + 7,50])
        rotate([90,0,0])
          indexed_joint_half("male");

      translate([0,base_diam / 2 - 7,50])
        rotate([-90,0,0])
          indexed_joint_half("male");
    }

    translate([0,0,50])
      rotate([90,0,0])
        cylinder(h = 100, d = bolt_diam, center = true);
  }
}

module mounting_base(height, outer_diam, thickness, hole_diam, center = false) {
  translate([0,0, center ? 0 : height / 2]){
    difference(){
      cylinder(h = height, d = outer_diam, center = true);
      cylinder(h = height + 1, d = outer_diam - thickness * 2, center = true);
      rotate([90,0,0]){
        cylinder(h = outer_diam+10, d = hole_diam, center = true);
      }
    }
  }
}

module pole_connection() {
  base_diam = 30;
  h_connection = 100;
  mounting_base(height = h_connection,
         outer_diam = base_diam,
         thickness = 5,
         hole_diam = 6,
         center = false);
  translate([0, 0, h_connection])
    handle(base_diam = base_diam,
        flange_radius = 22,
        bolt_diam = 8);
}

