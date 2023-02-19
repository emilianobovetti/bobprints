$fa = 6;
$fs = 0.25;

height = 50;
radius = 10;
loops = 10;
thickness = 2;
step_len = radius / 10;

loop_len = sqrt((height / loops) ^ 2 + (2 * PI * radius) ^ 2);
steps = ceil(1.1 * loop_len * loops / step_len);

// [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ]
x = 0.5;

linear_extrude(height = 50, twist = 360 * 10) translate([ 4, 0 ])
    scale([ 0.5, 1 ]) circle(r = 2);
