$fn = 100;

inner_diameter = 17.3;
inner_radius = inner_diameter / 2;
outer_diameter = 1.2 * inner_diameter;
outer_radius = outer_diameter / 2;
base_z_offset = 8.65;
max_thickness = 7.2;

module lorenz_loop() translate([ -6.35, -7 ]) scale(0.25) offset(r = 0.5)
    import(file = "lorenz-loop.svg");

translate([ 0, -3.4, base_z_offset ]) union() {
  // drawing
  translate([ 0, 0, 1.8 ]) linear_extrude(height = 0.4) lorenz_loop();

  // base
  linear_extrude(height = 1.8) difference() {
    hull() scale(1.1) lorenz_loop();

    translate([ 0, 1.3 ]) difference() {
      translate([ 0, 5 ]) square(13, center = true);

      translate([ 5, 0 ]) circle(6);
      translate([ -5, 0 ]) circle(6);
    }

    translate([ 0, -2.5 ]) difference() {
      translate([ 0, -2 ]) square(5, center = true);

      translate([ 2, 0 ]) circle(2.5);
      translate([ -2, 0 ]) circle(2.5);
    }
  }
}

// ring
rotate([ 90, 0 ]) difference() {
  cylinder(h = max_thickness, r = outer_radius);
  translate([ 0, 0, -max_thickness / 2 ])
      cylinder(h = max_thickness * 2, r = inner_radius);

  rotate([ 3, 0, 0 ]) translate([ 0, 0, max_thickness ])
      cube([ outer_diameter * 1.1, outer_diameter * 1.1, max_thickness ],
           center = true);
}

pin_h = 0.5;
pin_r = 0.3;

pillar_r = 0.6;
pillar_h = outer_radius + base_z_offset - pin_h;

module pin(position) translate([ position.x, position.y, pillar_h ])
    cylinder(h = pin_h, r = pin_r);

module supports() {
  function pillar_offset(len, x) = (len * x) + (1 - 2 * x) * pillar_r;

  s1_x = 13.5;
  s1_y = 2.9;

  translate([ -s1_x / 2, s1_y ]) {
    pin([ pillar_offset(s1_x, 0), pillar_r ]);
    pin([ pillar_offset(s1_x, 0.25), 0.36 ]);
    pin([ pillar_offset(s1_x, 0.5), -2 ]);
    pin([ pillar_offset(s1_x, 0.75), 0.36 ]);
    pin([ pillar_offset(s1_x, 1), pillar_r ]);
  }

  s3_x = 14.6;
  s3_y = 0.6;

  translate([ -s3_x / 2, s3_y ]) {
    pin([ pillar_offset(s3_x, 0), 0 ]);
    pin([ pillar_offset(s3_x, 0.25), 0 ]);
    pin([ pillar_offset(s3_x, 0.75), 0 ]);
    pin([ pillar_offset(s3_x, 1), 0 ]);
  }

  s2_x = 14.7;
  s2_y = (s1_y + s3_y) / 2 + pin_r;

  translate([ -s2_x / 2, s2_y ]) {
    pin([ pillar_offset(s2_x, 0), 0 ]);
    pin([ pillar_offset(s2_x, 0.25), 0 ]);
    pin([ pillar_offset(s2_x, 0.75), 0 ]);
    pin([ pillar_offset(s2_x, 1), 0 ]);
  }

  b1_len = max(s1_x, s2_x);

  translate([ -b1_len / 2, 2.1 ]) hull() {
    cube([ b1_len, 1.7, 0.01 ]);
    translate([ 0, -1.8, pillar_h ]) cube([ b1_len, 3.5, 0.01 ]);
  }

  s4_x = 11.3;
  s4_y = -4.6;

  translate([ -s4_x / 2, s4_y ]) {
    pin([ pillar_offset(s4_x, 0), 0 ]);
    pin([ pillar_offset(s4_x, 0.33), 0 ]);
    pin([ pillar_offset(s4_x, 0.66), 0 ]);
    pin([ pillar_offset(s4_x, 1), 0 ]);
  }

  s6_x = 5;
  s6_y = -7.65;

  translate([ -s6_x / 2, s6_y ]) {
    pin([ pillar_offset(s6_x, 0), 0 ]);
    pin([ pillar_offset(s6_x, 0.5), 0.95 ]);
    pin([ pillar_offset(s6_x, 1), 0 ]);
  }

  s5_x = 9.7;
  s5_y = (s4_y + s6_y) / 2 + pin_r;

  translate([ -s5_x / 2, s5_y ]) {
    pin([ pillar_offset(s5_x, 0), 0 ]);
    pin([ pillar_offset(s5_x, 0.33), 0 ]);
    pin([ pillar_offset(s5_x, 0.66), 0 ]);
    pin([ pillar_offset(s5_x, 1), 0 ]);
  }

  b2_len = max(s4_x, s5_x, s6_x);

  translate([ -b2_len / 2, -8 ]) hull() {
    cube([ b2_len, 3, 0.01 ]);
    translate([ 0, 0, pillar_h ]) cube([ b2_len, 3.7, 0.01 ]);
  }
}

color([ 0.8, 0.8, 0.8 ]) translate([ 0, 0, -outer_radius ]) supports();
