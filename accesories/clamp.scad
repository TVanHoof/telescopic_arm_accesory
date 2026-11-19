use <../accesory_base.scad>

module clamp() {
  h = 20;
  w = 150;
  l = 100;

  //base plate
  translate([0,0,h/2])
  accesory_base();

  //mounting mechanism
  s = 50;
  bore_d = s * 0.75;        // 37.5 - fixed interface for clamp_adapter()
  slit_w = 4;               // opening of the split collars
  ear_width = 16;           // ear width per side, along Y
  ear_height = 12;          // ear height above the block top
  screw_d = 8;              // M8 thumb screws
  screw_hole_d = screw_d + 0.5;
  screw_x = [-12, 12];      // two screws per collar, spaced along X
  nut_AF = 13;              // M8 hex nut across flats
  nut_t = 6.5;              // M8 nut thickness
  washer_d = 16;
  washer_depth = 1.5;

  difference(){
    union(){
      for (x = [-1,1]){
        translate([x * (w - s)/2,0,h + s/2]){
          union(){
            cube([s, s, s], center = true);

            // ears on both sides of the slit, above the block
            for (y = [-1,1]){
              translate([
                  0,
                  y * (slit_w/2 + ear_width/2),
                  s/2 + ear_height/2
              ])
                cube([s, ear_width, ear_height], center = true);
            }
          }
        }
      }
    }

    // horizontal bore through both collars
    translate([0,0,h+s/2])
      rotate([0,90,0])
        cylinder(d = bore_d, h = w + 1, center = true);

    // slit and screw hardware for each collar
    for (x = [-1,1]){
      translate([x * (w - s)/2,0,h + s/2]){

        // slit from the bore up through the ears
        translate([0, 0, (s/2 + ear_height + 1)/2])
          cube([s + 2, slit_w, s/2 + ear_height + 1], center = true);

        for (dx = screw_x){
          // clearance through both ears
          translate([dx, 0, s/2 + ear_height/2])
            rotate([90,0,0])
              cylinder(
                  h = 2 * (slit_w/2 + ear_width) + 2,
                  d = screw_hole_d,
                  center = true
              );

          // captive nut on the -Y ear
          translate([
              dx,
              -(slit_w/2 + ear_width) + nut_t/2,
              s/2 + ear_height/2
          ])
            rotate([90,0,0])
              cylinder(
                  h = nut_t + 0.5,
                  r = nut_AF / sqrt(3),
                  center = true,
                  $fn = 6
              );

          // washer seat on the +Y ear
          translate([
              dx,
              (slit_w/2 + ear_width) - washer_depth/2,
              s/2 + ear_height/2
          ])
            rotate([90,0,0])
              cylinder(
                  h = washer_depth + 0.2,
                  d = washer_d,
                  center = true
              );
        }
      }
    }
  }
}

// Split adapter sleeve for mounting a smaller shaft in the 37.5 mm bore.
// Print one per shaft diameter; its slit lines up with the clamp slits.
module clamp_adapter(
  shaft_d = 30,
  outer_d = 37.2,
  length = 150,
  slit_w = 2,
  set_screw = true,
  set_screw_d = 4,
  boss_d = 12,
  boss_length = 8,
  screw_pos = 0          // keep this in the 50 mm gap between the collars
) {
  ro = outer_d / 2;
  ri = shaft_d / 2;

  difference(){
    union(){
      rotate([0,90,0])
        cylinder(d = outer_d, h = length, center = true);

      if (set_screw) {
        // radial boss for an M4 thumb screw that locks the shaft to the sleeve
        translate([screw_pos, ro + boss_length/2 - 0.5, 0])
          rotate([90,0,0])
            cylinder(d = boss_d, h = boss_length + 1, center = true);
      }
    }

    // shaft bore
    rotate([0,90,0])
      cylinder(d = shaft_d, h = length + 2, center = true);

    // slit aligned with the clamp slit; dipped 1 mm into the bore so the
    // slot fully breaks through instead of meeting the bore at a tangent
    translate([0, 0, (ri + ro)/2])
      cube([length + 2, slit_w, ro - ri + 2], center = true);

    if (set_screw) {
      // thumb screw hole, from the boss into the shaft
      translate([screw_pos, (ro + boss_length)/2, 0])
        rotate([90,0,0])
          cylinder(
              h = ro + boss_length + 2,
              d = set_screw_d + 0.5,
              center = true
          );
    }
  }
}

// Example:
// clamp_adapter(shaft_d = 30);

