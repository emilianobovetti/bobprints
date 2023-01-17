$fn = 20;

minkowski() {
  linear_extrude(height = 0.1) import(file = "ess.svg");
  sphere(r = 1);
}
