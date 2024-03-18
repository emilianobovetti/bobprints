$fn = 100;

base_height = 130;
raw_outer_rad = 75 / 2;
brace_height = 35;
brace_rad = 24 / 2;

material_shrinking = 0.3;
shrinking_compensation_height = 2;

rad_shrinking_adjustment = material_shrinking / 2;
outer_rad = raw_outer_rad + rad_shrinking_adjustment;

hull() {
  cylinder(r = raw_outer_rad, h = 0.1);

  translate([0, 0, shrinking_compensation_height])
    cylinder(r = outer_rad, h = 0.1);
}

translate([0, 0, shrinking_compensation_height])
  cylinder(r = outer_rad, h = base_height - shrinking_compensation_height);

translate([0, 0, base_height]) difference() {
  cylinder(r = outer_rad, h = 35);

  translate([0, outer_rad + 0.5, brace_rad + rad_shrinking_adjustment]) rotate([90, 0]) hull() {
    cylinder(r = brace_rad + rad_shrinking_adjustment, h = outer_rad * 2 + 1);
    translate([0, brace_height]) cylinder(r = brace_rad + rad_shrinking_adjustment, h = outer_rad * 2 + 1);
  }
}
