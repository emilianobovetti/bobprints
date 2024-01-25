$fn = 100;

scale(0.5) {
  cube([110, 110, 2]);
  translate([2, 2, 1]) linear_extrude(3) offset(delta = 0.01) import(file = "qrcode.svg");
}
