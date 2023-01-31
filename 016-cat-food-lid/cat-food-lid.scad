$fn = 100;

hole_diameter = 75.5;
edge_thickness = 1.5;
edge_height = 8;
base_height = 1;

internal_radius = hole_diameter / 2;
external_radius = internal_radius + edge_thickness;

cylinder(h = base_height, r = external_radius);

translate([ 0, 0, base_height ]) difference() {
  cylinder(h = edge_height, r = external_radius);
  cylinder(h = edge_height + .01, r = hole_diameter / 2);
}
