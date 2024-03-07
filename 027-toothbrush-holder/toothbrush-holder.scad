$fn = 50;

module attach() {
  base_width = 4.5;
  base_height = 5.7;
  indent_height = 3;
  base_radius = 3.975;

  translate([-0.5 - base_width / 2, -0.75 - base_height / 2]) linear_extrude(height = 12.6)
    polygon(points = [
      [0.5, 0.75],
      [0, 0.75 + base_height / 2],
      [0.5, 0.75 + base_height],
      [0.5 + base_width / 2, 7.5],
      [0.5 + base_width, 0.75 + base_height],
      [0.5 + base_width - 0.8, 0.75 + base_height - indent_height / 2],
      [0.5 + base_width, 0.75 + base_height - indent_height],
      [0.5 + base_width, 0.75],
      [0.5 + base_width / 2, 0],
    ]);

    cylinder(r = base_radius, h = 0.85);

    translate([0, 0, -0.77]) difference() {
      sphere(r = base_radius);
      translate([0, 0, -3.2]) cube(base_radius * 2, center = true);
    }

}

module isosceles(length, vertex_angle) polygon(points = [
  [0, 0],
  [length, 0],
  [length * cos(vertex_angle), length * sin(vertex_angle)]
]);

module rounded_edge(radius, angle = 90)
  translate([0, 0, radius]) rotate([270, 90]) linear_extrude(height = depth) difference() {
    intersection() {
      circle(r = radius);
      isosceles(length = radius * 10, vertex_angle = angle);
    }

    circle(r = radius - thickness);
  }

thickness =4;
height = 40;
width = 22;
depth = 45;
hole_margin = 10;

translate([0, 0, height - thickness]) difference() {
  cube([width, depth, thickness]);
  translate([width / 2, hole_margin, -0.1]) cylinder(h = thickness + 0.2, r = 7);
  translate([width / 2, depth - hole_margin, -0.1]) cylinder(h = thickness + 0.2, r = 7);
}

translate([width / 2, 0, thickness]) {
  translate([0, hole_margin]) rotate(90) attach();
  translate([0, depth - hole_margin]) rotate(90) attach();
}

edge_radius = 7;
side_slope = 10;
extra_base_length = (height - edge_radius * 2) * tan(side_slope);

translate([- extra_base_length, 0]) {
  cube([width + extra_base_length, depth, thickness]);
  rounded_edge(radius = edge_radius, angle = 90 + side_slope);

  translate([0, 0, edge_radius])
    rotate([0, side_slope])
    translate([-edge_radius, 0])
    cube([thickness, depth, side_slope != 0 ? extra_base_length / sin(side_slope) : height - edge_radius * 2]);
}

translate([0, 0, height]) mirror([0, 0, 1]) rounded_edge(radius = edge_radius, angle = 90 - side_slope);
