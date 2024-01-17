$fn = 100;

arm_width = 15;
arm_length = 112;
arm_thickness = 2;
arm_hole_border = 4;
arm_hole_radius = arm_width / 2 - arm_hole_border;
pin_space = 0.5;
lock_ext_width = 5;
lock_ext_length = 11.5;

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

  glass() translate([ 0, 0, pin_height ])
      cylinder(h = arm_thickness, r = arm_width / 2);
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
  wall_thickness = 3;
  base_length = arm_width + wall_thickness;
  base_height = 3;
  base_width = 20;
  border_radius = 2;
  wall_offset = (base_length / 2) - (wall_thickness / 2);

  rotate(90) linear_extrude(base_height) half_rounded_square(
      [ base_width, base_length - wall_thickness ], border_radius);

  translate([ wall_offset, 0, base_height ]) mirror([ 1, 0 ])
      beveled_border(length = base_width, height = wall_thickness);

  translate([ wall_offset, 0 ])
      screw_wall(base_width, wall_thickness, border_radius, screw_housing);
}

module screw_wall(base_width, thickness, border_radius, housing = 1) {
  width = 26;
  height = 16;
  bevel_height = height * 0.6;
  hole_radius = 1.75;
  hole_position = 12;
  hole_dist = 15;

  rotate([ 90, 0, 90 ]) difference() {
    // wall
    linear_extrude(height = thickness) {
      hull() {
        translate([ -base_width / 2, 0 ]) square(size = [ base_width, 1 ]);
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

module hinge(mirror_screw_supports = 0) {
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
    fst_z_offset = -pin_space - (mirror_screw_supports == 1 ? arm_thickness : 0);
    mirror([ 0, 0, mirror_screw_supports ]) translate([ arm_hole_x_offset, 0, fst_z_offset ]) {
      pivot();
      mirror([ 0, 0, 1 ]) rotate(270) front_screw_support();
    }

    // central pivot
    translate([ -arm_hole_x_offset, 0 ]) mirror([ 0, 0, 1 ]) pivot();
  }

  translate(v = [ -arm_hole_x_offset, 0, -arm_thickness - pin_space ]) {
    // second arm
    linear_extrude(height = arm_thickness) difference() {
      second_arm_ext = lock_ext_length - 2;

      translate([ second_arm_ext / 2, 0 ])
          stadium([ arm_length + second_arm_ext, arm_width ]);

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
    snd_z_offset = pin_space + (mirror_screw_supports == 0 ? arm_thickness : 0);
    mirror([ 0, 0, mirror_screw_supports ]) translate([ -arm_hole_x_offset, 0, snd_z_offset ]) {
      mirror([ 0, 0, 1 ]) pivot();
      rotate(270) back_screw_support();
    }
  }
}

module left_hinge() hinge(mirror_screw_supports = 0);
module right_hinge() hinge(mirror_screw_supports = 1);

rotate($preview ? 0 : [ 90, 0, 45 ]) left_hinge();
