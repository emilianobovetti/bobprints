base_num = 78;
squares = 8;
step = 1;
side = 20;

module square(num) {
  cube([side, side, 1]);

  translate([1, 1, 1]) linear_extrude(0.2) text(text = str(num), size = side / 5);
}

for (idx = [0:ceil(squares / 2) - 1])
  translate([(side + 2) * idx, 0]) square(idx * step * 2 + base_num);

for (idx = [0:floor(squares / 2) - 1])
  translate([(side / 2) + (side + 2) * idx, -side - 2]) square(idx * step * 2 + step + base_num);
