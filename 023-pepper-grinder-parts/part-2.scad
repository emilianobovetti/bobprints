$fn = 100;

difference() {
  union() {
    cylinder(r = 6.3, h = 2.5);

    translate([0, 0, 2.5]) {
      rad = 4;

      cylinder(r = rad, h = 12);
      translate([rad, 0]) cylinder(r = 1.4, h = rad);
      translate([-rad, 0]) cylinder(r = 1.4, h = rad);
      translate([0, rad]) cylinder(r = 1.4, h = rad);
      translate([0, -rad]) cylinder(r = 1.4, h = rad);
    }
  }

  translate([0, 0, -0.5]) cylinder(r = 3.4, h = 15.5, $fn = 5);
}
