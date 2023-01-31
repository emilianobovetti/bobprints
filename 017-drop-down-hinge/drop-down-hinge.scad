$fn = 100;

arm_width = 10;
arm_length = 110;
arm_thickness = 2;
arm_hole_radius = 2.5;
pin_space = 0.3;
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

module pivot(pin_height = arm_thickness + pin_space * 2) {
  cylinder(r = arm_hole_radius - pin_space, h = pin_height);
  translate([ 0, 0, pin_height ]) cylinder(h = 1.2, r = arm_width / 2);
}

module half_rounded_square(size, border_radius = 0.5) hull() {
  y_offset = (size.y / 2) - border_radius;

  translate([ 0, y_offset ]) stadium(size = [ size.x, border_radius * 2 ]);
  translate([ 0, -y_offset ])
      square(size = [ size.x, border_radius ], center = true);
}

module screw_support() {
  base_length = arm_width;
  border_radius = 2;

  rotate(90) linear_extrude(height = 1)
      half_rounded_square([ arm_width, base_length ], border_radius);

  screw_wall(base_length, border_radius);
}

module screw_wall(base_length, border_radius) {
  screw_wall_width = 26;
  screw_wall_thickness = 2;
  screw_wall_height = 11.5;
  screw_wall_offset = 0.55 + screw_wall_height;
  screw_wall_step_1 = screw_wall_offset * 0.6;
  screw_hole_radius = 3.5 / 2;
  screw_hole_position = screw_wall_offset - 4;
  screw_hole_dist = 15;

  translate([ base_length / 2 - screw_wall_thickness, 0 ])
      rotate(a = [ 90, 0, 90 ]) difference() {
    linear_extrude(height = screw_wall_thickness) {
      hull() {
        translate([ -arm_width / 2, 0 ]) square(size = [ arm_width, 1 ]);
        translate([ 0, screw_wall_step_1 ]) stadium([ screw_wall_width, 7 ]);
      }

      hull() {
        translate([ 0, screw_wall_step_1 ]) stadium([ screw_wall_width, 7 ]);
        translate([ 0, screw_wall_offset ])
            stadium([ screw_wall_width, border_radius ]);
      }
    }

    translate([
      screw_hole_dist / 2, screw_hole_position, -screw_wall_thickness / 2
    ]) {
      cylinder(h = screw_wall_thickness * 2, r = screw_hole_radius);
      translate([ 0, 0, -0.75 ]) sphere(r = screw_hole_radius * 2);
    }

    translate([
      -screw_hole_dist / 2, screw_hole_position, -screw_wall_thickness / 2
    ]) {
      cylinder(h = screw_wall_thickness * 2, r = screw_hole_radius);
      translate([ 0, 0, -0.75 ]) sphere(r = screw_hole_radius * 2);
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
      mirror([ 0, 0, 1 ]) screw_support();
    }

    // central pivot
    translate([ -arm_hole_x_offset, 0 ]) mirror([ 0, 0, 1 ]) pivot();
  }

  // rotate(-45)
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
      rotate(180) screw_support();
    }
  }
}

rotate($preview ? 0 : [ 90, 0, 45 ]) hinge();
