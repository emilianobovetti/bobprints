$fn = 100;

inner_diameter = 17.3;
inner_radius = inner_diameter / 2;
outer_diameter = 1.2 * inner_diameter;
outer_radius = outer_diameter / 2;
base_z_offset = 8.65;
max_thickness = 7.2;

module lorenz_loop() translate([ -6.35, -7 ]) scale(0.25) offset(r = 0.5)
    import(file = "lorenz-loop.svg");

module ring_top() union() {
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

module ring_circle() difference() {
  cylinder(h = max_thickness, r = outer_radius);

  translate([ 0, 0, -max_thickness / 2 ])
      cylinder(h = max_thickness * 2, r = inner_radius);

  rotate([ 3, 0, 0 ]) translate([ 0, 0, max_thickness ])
      cube([ outer_diameter * 1.1, outer_diameter * 1.1, max_thickness ],
           center = true);

  translate([ -10, base_z_offset, -10 ]) cube([ 20, 5, 20 ]);
}

translate([ 0, 15 ]) ring_top();

ring_circle();
