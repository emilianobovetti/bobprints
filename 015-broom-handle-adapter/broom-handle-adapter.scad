$fn = 50;

module helix(height = 1, radius = 1, loops = 1, steps = 100) {
  steps_per_loop = steps / loops;
  z_step = height / steps;

  first_step_frac = (1 % steps_per_loop) / (steps_per_loop - 1);
  first_step_angle = 360 * first_step_frac;

  p1 = [ radius * sin(first_step_angle), z_step ];
  p2 = [ radius * sin(first_step_angle), 0 ];

  p01 = sqrt(p1[0] ^ 2 + p1[1] ^ 2);
  p03 = sqrt(p2[0] ^ 2 + p2[1] ^ 2);
  p12 = sqrt((p1[0] - p2[0]) ^ 2 + (p1[1] - p2[1]) ^ 2);
  raise_angle = acos((p01 ^ 2 + p03 ^ 2 - p12 ^ 2) / (2 * p01 * p03));

  union() for (step = [0:steps]) {
    loop_frac = (step % steps_per_loop) / (steps_per_loop - 1);
    angle = 360 * loop_frac;
    current_point = [ radius * cos(angle), radius * sin(angle), step * z_step ];

    translate(current_point) rotate([ raise_angle, 0, angle ]) children();
  }
}

module bottom_pin() {
  rotate([ 0, -90, 0 ]) hull() {
    cylinder(h = 2.5, r = 2.5, center = true);
    translate([ 1, 0 ]) cylinder(h = 2.5, r = 2, center = true);
  }
}

module upper_pin() {
  rotate([ 0, -90, 0 ]) hull() {
    cylinder(h = 6, r = 1.75, center = true);
    translate([ 4, 0 ]) cylinder(h = 6, r = 1.75, center = true);
  }
}

height = 44;

module main_hole() translate([ 0, 0, 2 ]) cylinder(h = height + .01, r = 11.3);

union() {
  difference() {
    cylinder(h = height, r = 12.8);

    main_hole();
  }

  helix(height = height - 2.2, radius = 11.3, loops = 11, steps = 1000)
      rotate([ 0, -20, 0 ]) cube([ 1, 0.8, 1.9 ]);

  translate([ 14, 0, 2.7 ]) bottom_pin();
  translate([ -14, 0, 2.7 ]) bottom_pin();

  difference() {
    union() {
      translate([ 10, 9.5, height - 7 ]) rotate(18) upper_pin();
      translate([ -10, 9.5, height - 7 ]) rotate(-18) upper_pin();
    }

    main_hole();
  }
}
