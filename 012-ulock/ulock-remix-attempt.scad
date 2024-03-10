$fn = 50;

translate([0, 0, 2]) {
  cylinder(r = 2, h = 17);
  rotate_extrude() right_triangle(base = 5, height = 3);

  translate([12, -5]) cube([1.5, 10, 17]);
  translate([12, 5]) rotate([90, 270])
    linear_extrude(height = 10) right_triangle(base = 3, height = 3);
}

linear_extrude(height = 2) hull() {
  circle(r = 5);
  translate([12, -5]) square([1.5, 10]);
}

module right_triangle(base, height) polygon(
  points = [ [ 0, 0 ], [ base, 0 ], [ 0, height ] ],
  paths = [[ 0, 1, 2 ]]
);
