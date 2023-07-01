$fn = 100;

module pin(width, height, thickness) linear_extrude(height = thickness) {
  square([ width, height ]);

  translate([ 5, 0 ]) mirror([ 0, 1 ]) isosceles(base = 10, height = 20);
}

module isosceles(base, height)
    polygon(points = [ [ -base / 2, 0 ], [ base / 2, 0 ], [ 0, height ] ],
            paths = [[ 0, 1, 2 ]]);

module heart(width) translate([ -width / 2, 0 ]) scale(width / 100)
    import(file = "heart.svg");

module plant_label(lines, font = "odstemplik:style=Bold", font_size = 10,
                   font_spacing = 1, board_size = 100) union() {
  heart_thickness = 2.2;
  text_thickness = 1.4;
  pin_thickness = 2;
  pin_width = 10;
  pin_height = 80;
  pin_offset = -0.0004 * pow(board_size, 2) - 0.02 * board_size + 4;

  translate([ -pin_width / 2, pin_offset - board_size / 2 - pin_height ])
      pin(pin_width, pin_height, pin_thickness);

  linear_extrude(height = heart_thickness) heart(width = board_size);

  line_height = font_size * 1.2;
  max_offset = board_size / 2;
  mid_offset = max_offset / 2;

  last_index = len(lines) - 1;
  base_text = mid_offset - (line_height * last_index * 0.5);

  translate([ 0, 20 - base_text, heart_thickness ]) color([ 0.5, 0, 0 ])
      linear_extrude(height = text_thickness) for (idx = [0:last_index])
          translate([ 0, -line_height * idx ])
              text(lines[idx], halign = "center", font = font, size = font_size,
                   spacing = font_spacing);
}

plant_label([ "Pesco", "Duchessa D'Este" ], font_size = 10.5);
// plant_label([ "Susino", "Shiro", "Goccia d'Oro" ], font_size = 10.5);
// plant_label(["Lavanda"], font_size = 14);
// plant_label(["Rosmarino"], font_size = 14);
// plant_label(["Salvia"], font_size = 14);
// plant_label(["Basilico"], font_size = 14);
// plant_label(["Menta"], font_size = 14);
// plant_label(["Timo"], font_size = 14);
// plant_label(["Frangipane"], font_size = 14);
// plant_label(["Limone"], font_size = 14);
// scale(0.3) plant_label(["Patate"], font_size = 14);
// plant_label([ "Erba gatta", "digestiva" ], font_size = 14);
// plant_label([ "Erba gatta", "stimolante" ], font_size = 14);
