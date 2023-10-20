int numberOfSides = 3;
int radius = 135;
int pointsPerSide = 10;

Shape shape;

PShader grainShader;

void setup() {
  size(1080, 1080, P2D);

  frameRate(1);

  smooth(4);

  grainShader = loadShader("grain.frag");
}

void draw() {
  colorMode(RGB, 255);
  background(245);

  translate(width/2, height/2);
  rotate(-HALF_PI);

  rectMode(CENTER);
  noStroke();

  for(int i=4; i>=0; i--) {
    float rectSize = 0.6 * width;
    fill((i) * 10, i * 10, (i + 1) * 10);
    rect((i - 2) * 14, (i - 2) * 14, rectSize, rectSize);
  }

  filter(grainShader);

  shape = new Shape(frameCount + 2, 4.0 * 3.14159 / (frameCount + 2), radius, max(10, 30 - frameCount));
  shape.draw(-28, -28);


  saveFrame("frames_5/###.png");
}
