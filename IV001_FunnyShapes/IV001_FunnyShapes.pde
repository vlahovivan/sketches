int numberOfSides = 3;
int radius = 280;
int pointsPerSide = 10;

Shape shape;

void setup() {
  size(800, 800);

  frameRate(1);
}

void draw() {
  colorMode(RGB, 255);
  background(255);

  translate(width/2, height/2);
  rotate(-HALF_PI);

  shape = new Shape(frameCount + 2, radius, max(10, 30 - frameCount));
  shape.draw(0, 0);
}
