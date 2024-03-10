$fn = 50;

thickness = 5.8;

module base_surface() hull() {
  translate([1, 1]) circle(r = 1);
  translate([175, 1]) circle(r = 1);
  translate([18, 81]) circle(r = 18);
  translate([110, 81]) circle(r = 18);
  translate([158, 30]) circle(r = 18);
}

module base_solid() linear_extrude(height = thickness) difference() {
  base_surface();

  translate([5, 5]) circle(r = 2.6);
  translate([5, 60]) circle(r = 2.6);
  translate([60, 5]) circle(r = 2.6);
  translate([148, 5]) circle(r = 2.6);

  translate([30, 50]) {
    square([72, 27]);
    translate([-4, 1]) circle(r = 1.6);
    translate([-4, 26]) circle(r = 1.6);
    translate([76, 26]) circle(r = 1.6);
    translate([76, 1]) circle(r = 1.6);
  }

  translate([125, 65]) circle(r = 3.8);
}

difference() {
  base_solid();
  translate([10, 10, -0.01]) cube([170, 90, thickness - 2.2 + 0.01]);
  translate([74, 25, thickness - 0.4]) linear_extrude(height = 1) {
    text("Bobfil", size = 15, font = "Noto Serif", halign = "center");
    translate([0, -10]) text("- e v o -", size = 8, font = "Noto Serif Light", halign = "center");
  }
}
