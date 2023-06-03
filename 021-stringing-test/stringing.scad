$fn = 100;

// make sure cura has this layer height
layer_height = 0.2;

// these parameters need to be matched with the configuration
// of https://github.com/5axes/Calibration-Shapes plugin
change_layer = 20;
change_layer_offset = 40;

change_total_steps = 5;
base_height_mm = 2 * layer_height;
column_distance = 6;

module section(diameter = 1.5, width = column_distance, height,
               thickness = 0.2) union() {
  radius = diameter / 2;
  x_offset = width / 2;

  translate([ 0, 0, height ]) linear_extrude(thickness) hull() {

    translate([ -x_offset, 0 ]) circle(r = radius);
    translate([ x_offset, 0 ]) circle(r = radius);
  }

  translate([ -x_offset, 0 ]) cylinder(r = radius, h = height);
  translate([ x_offset, 0 ]) cylinder(r = radius, h = height);
}

translate([ 0, 0, 0.4 ]) {
  test_offset =
      (change_layer_offset * layer_height) - base_height_mm - layer_height;
  section_height_mm = change_layer * layer_height;

  // warmup section
  section(diameter = 1.5, width = column_distance, height = test_offset);

  for (step = [0:change_total_steps - 1])
    translate([ 0, 0, step * section_height_mm + test_offset ])
        section(diameter = 1.5, width = 6, height = section_height_mm);
}

translate([ -5, -2.5 ]) cube([ 10, 5, base_height_mm ]);
