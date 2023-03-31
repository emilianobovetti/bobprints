$fn = 100;

arm_width = 15;
arm_length = 112;
arm_thickness = 2;
arm_hole_border = 4;
arm_hole_radius = arm_width / 2 - arm_hole_border;
pin_space = 0.4;
lock_ext_width = 5;
lock_ext_length = 10;

module stadium(size) {
  radius = size.y / 2;
  orig = size.x / 2 - radius;

  hull() {
    translate([ orig, 0 ]) circle(radius);
    translate([ -orig, 0 ]) circle(radius);
  }
}

module glass() color("teal", 0.6) children();
module solid() color("gray") children();

module pivot(pin_height = arm_thickness + pin_space * 2) union() {
  solid() cylinder(r = arm_hole_radius - pin_space, h = pin_height);
  glass() translate([ 0, 0, pin_height ]) cylinder(h = 1.2, r = arm_width / 2);
}

module half_rounded_square(size, border_radius = 0.5) hull() {
  y_offset = (size.y / 2);

  translate([ 0, y_offset - border_radius ])
      stadium(size = [ size.x, border_radius * 2 ]);
  translate([ 0, -y_offset + (border_radius / 2) ])
      square(size = [ size.x, border_radius ], center = true);
}

module beveled_border(length, height) difference() {
  translate([ 0, -length / 2 ]) cube([ height, length, height ]);

  translate([ height, 0, height ]) rotate([ 90, 0 ])
      cylinder(h = length + 0.2, r = height, center = true);
}

module front_screw_support() screw_support(screw_housing = 1);
module back_screw_support() screw_support(screw_housing = -1);

module screw_support(screw_housing = 1) glass() union() {
  base_length = arm_width;
  base_height = 2;
  border_radius = 2;
  wall_thickness = 3;

  rotate(90) linear_extrude(base_height) translate([ 0, wall_thickness / 2 ])
      half_rounded_square([ arm_width, base_length - wall_thickness ],
                          border_radius);

  translate([ base_length / 2 - wall_thickness, 0, base_height ])
      mirror([ 1, 0 ])
          beveled_border(length = base_length, height = base_height);

  translate([ base_length / 2 - wall_thickness, 0 ])
      screw_wall(wall_thickness, border_radius, screw_housing);
}

module screw_wall(thickness, border_radius, housing = 1) {
  width = 30;
  height = 13;
  bevel_height = height * 0.6;
  hole_radius = 1.75;
  hole_position = 8;
  hole_dist = 15;

  rotate([ 90, 0, 90 ]) difference() {
    // wall
    linear_extrude(height = thickness) {
      hull() {
        translate([ -arm_width / 2, 0 ]) square(size = [ arm_width, 1 ]);
        translate([ 0, bevel_height ]) stadium([ width, 7 ]);
      }

      hull() {
        translate([ 0, bevel_height ]) stadium([ width, 7 ]);
        translate([ 0, height ]) stadium([ width, border_radius ]);
      }
    }

    // first screw housing hole
    translate([ hole_dist / 2, hole_position, thickness / 2 ]) {
      translate([ 0, 0, -thickness ])
          cylinder(h = thickness * 2, r = hole_radius);

      translate([ 0, 0, -thickness * 1.1 * housing ])
          sphere(r = hole_radius * 2);
    }

    // second screw housing hole
    translate([ -hole_dist / 2, hole_position, thickness / 2 ]) {
      translate([ 0, 0, -thickness ])
          cylinder(h = thickness * 2, r = hole_radius);

      translate([ 0, 0, -thickness * 1.1 * housing ])
          sphere(r = hole_radius * 2);
    }
  }
}

module hinge() {
  arm_hole_x_offset = (arm_length / 2) - (arm_width / 2);
  lock_pin_radius = lock_ext_width / 2;
  lock_pin_thickness = arm_thickness + pin_space;

  translate(v = [ arm_hole_x_offset, 0 ]) {
    // first arm
    linear_extrude(height = arm_thickness) difference() {
      stadium([ arm_length, arm_width ]);

      translate([ arm_hole_x_offset, 0 ]) circle(r = arm_hole_radius);

      // lock hole
      translate([ -arm_hole_x_offset, -arm_width / 2 ]) hull() {
        translate([ 0, -1 ]) square([ lock_ext_length, 1 ]);
        translate([ lock_ext_length - lock_pin_radius, lock_pin_radius ])
            circle(d = lock_ext_width + pin_space);
      }
    }

    // first pivot with screw support
    translate([ arm_hole_x_offset, 0, -pin_space ]) {
      pivot();
      mirror([ 0, 0, 1 ]) front_screw_support();
    }

    // central pivot
    translate([ -arm_hole_x_offset, 0 ]) mirror([ 0, 0, 1 ]) pivot();
  }

  translate(v = [ -arm_hole_x_offset, 0, -arm_thickness - pin_space ]) {
    // second arm
    linear_extrude(height = arm_thickness) difference() {
      union() {
        stadium([ arm_length, arm_width ]);

        // lock extension arm
        translate([ arm_hole_x_offset, lock_pin_radius - (arm_width / 2) ]) {
          stadium([ lock_ext_length * 2, lock_ext_width ]);
        }
      }

      translate([ arm_hole_x_offset, 0 ]) circle(r = arm_hole_radius);
      translate([ -arm_hole_x_offset, 0 ]) circle(r = arm_hole_radius);
    }

    // lock pin
    translate([
      arm_hole_x_offset + lock_ext_length - lock_pin_radius,
      lock_pin_radius - (arm_width / 2),
      arm_thickness
    ]) {
      cylinder(h = lock_pin_thickness, r = lock_pin_radius);
    }

    // second pivot with screw support
    translate([ -arm_hole_x_offset, 0, arm_thickness + pin_space ]) {
      mirror([ 0, 0, 1 ]) pivot();
      rotate(180) back_screw_support();
    }
  }
}

rotate($preview ? 0 : [ 90, 0, 45 ]) hinge();
