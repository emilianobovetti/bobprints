length = 80;
width = 39;
half_w = width / 2;
thickness = 10;
half_t = thickness / 2;

rotate_extrude(angle = 180) translate([half_w, 0]) rotate(180 / 8) circle(r = half_t, $fn = 8);
translate([half_w, 0]) rotate([90, 180 / 8]) cylinder(r = half_t, h = length, $fn = 8);
translate([-half_w, 0]) rotate([90, 180 / 8]) cylinder(r = half_t, h = length, $fn = 8);
