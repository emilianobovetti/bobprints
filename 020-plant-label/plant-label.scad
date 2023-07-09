$fn = 100;

module pin(width, height, thickness) linear_extrude(height = thickness) {
  square([ width, height ]);

  translate([ width / 2, 0 ]) mirror([ 0, 1 ])
      isosceles(base = width, height = 20);
}

module isosceles(base, height)
    polygon(points = [ [ -base / 2, 0 ], [ base / 2, 0 ], [ 0, height ] ],
            paths = [[ 0, 1, 2 ]]);

module heart(width) translate([ -width / 2, 0 ]) scale(width / 100)
    import(file = "heart.svg");

text_thickness = 1.4;
serif_bold = "odstemplik:style=Bold";
default_font_size = 10;
default_font_spacing = 1;

module text_line(content, thickness, font_family, font_size, font_spacing)
    linear_extrude(height = thickness)
        text(content, halign = "center", font = font_family, size = font_size,
             spacing = font_spacing);

module text_label(lines, thickness = text_thickness, font_family = serif_bold,
                  font_size = default_font_size,
                  font_spacing = default_font_spacing) {
  line_height = font_size * 1.2;

  for (idx = [0:max(len(lines) - 1, 0)])
    translate([ 0, -line_height * idx ])
        text_line(lines[idx], thickness, font_family, font_size, font_spacing);
}

module plant_label(lines, font_size = default_font_size,
                   width_scale = 1) union() {
  board_size = width_scale * 100;
  heart_thickness = 2.2;
  pin_thickness = 2;
  pin_width = width_scale * 10;
  pin_height = 80;
  pin_offset = -0.0004 * pow(board_size, 2) - 0.02 * board_size + 4;

  translate([ -pin_width / 2, pin_offset - board_size / 2 - pin_height ])
      pin(pin_width, pin_height, pin_thickness);

  linear_extrude(height = heart_thickness) heart(width = board_size);

  line_height = font_size * 1.2;

  last_index = len(lines) - 1;
  base_offset = 0.183 * board_size - 9;
  center_offset = 0.23 * board_size - 5;
  text_offset = base_offset - center_offset +
                min(line_height * last_index / 2, center_offset);

  translate([ 0, text_offset, heart_thickness ]) color([ 0.5, 0, 0 ])
      text_label(lines);
}

module plant_label_base(width_scale = 1)
    plant_label(lines = [], width_scale = width_scale);

// label = [ "Pesco", "Duchessa D'Este" ];
// label = [ "Susino", "Shiro", "Goccia d'Oro" ];

// label = ["Lavanda"];
// label = ["Rosmarino"];
// label = ["Salvia"];
// label = ["Basilico"];
// label = ["Menta"];
// label = ["Timo"];
// label = ["Frangipane"];
// label = ["Limone"];
// label = [ "Erba gatta", "digestiva" ];
// label = [ "Erba gatta", "stimolante" ];
// label = ["Patate"];
// label = ["Zucchine"];
label = ["Pomodori"];
// label = ["Aglio"];

// width_scale = 1;
width_scale = 0.6;
// font_size = 14;
font_size = 10.5;

plant_label(lines = label, font_size = font_size, width_scale = width_scale);
// plant_label_base(width_scale = width_scale);
// text_label(lines = label, font_size = font_size);
