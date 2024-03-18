$fn = 100;

base_height = 80;
raw_outer_rad = 75 / 2;
raw_innter_rad = 72 / 2;
border_width = 1;

material_shrinking = 0.3;
shrinking_compensation_height = 2;

outer_rad = raw_outer_rad + material_shrinking / 2;
innter_rad = raw_innter_rad + material_shrinking / 2;

hull() {
  cylinder(r = raw_outer_rad, h = 0.1);

  translate([0, 0, shrinking_compensation_height])
    cylinder(r = outer_rad, h = 0.1);
}

translate([0, 0, shrinking_compensation_height])
  cylinder(r = outer_rad, h = base_height - shrinking_compensation_height);

translate([0, 0, base_height]) {
  linear_extrude(height = 10) difference() {
    circle(r = outer_rad);
    circle(r = innter_rad);
  }

  rotate_extrude() translate([innter_rad - border_width, 0]) difference() {
    square([border_width, border_width]);
    translate([0, border_width]) circle(r = border_width);
  }
}
