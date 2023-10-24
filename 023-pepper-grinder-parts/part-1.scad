$fn = 100;

difference() {
  union() {
    cylinder(r = 10, h = 5.7);
    cylinder(r = 5, h = 8.7);
  }

  translate([0,0, -5]) cylinder(r = 2.36, h = 20);
}
