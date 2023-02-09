$fn = 100;

module box(size, border) difference() {
  center = true;
  cube(size, center);

  cube(size - border, center);
  translate([ 0, 0, (size.z / 2) - (border.z / 2) ])
      cube([ size.x - border.x, size.y - border.y, border.z * 1.01 ], center);
}

module walls(size, border) difference() {
  center = true;

  cube(size, center);
  cube([ size.x - border.x, size.y - border.y, size.z * 1.01 ], center);
}

box_size = [ 50, 40 ];
box_border = [ 3.2, 3.2, 3.2 ];

taller_box_size = [ box_size.x, box_size.y, 16 ];
shorter_box_size = [ box_size.x, box_size.y, 11 ];

// junction_size = ;
junction_height = 1.5;
junction_border = [ 1.5, 1.5 ];

translate([ box_size.x / 2 + 1, 0, taller_box_size.z / 2 ]) {
  box(taller_box_size, box_border);

  translate([ 0, 0, (taller_box_size.z / 2) + (junction_height / 2) ])
      walls([ box_size.x, box_size.y, junction_height ], junction_border);
}

translate([ -box_size.x / 2 - 1, 0, shorter_box_size.z / 2 ]) {
  box(shorter_box_size, box_border);
  translate([ 0, 0, (shorter_box_size.z / 2) + (junction_height / 2) ]) walls(
      [
        box_size.x - box_border.x + junction_border.x,
        box_size.y - box_border.y + junction_border.y,
        junction_height
      ],
      junction_border);
}
