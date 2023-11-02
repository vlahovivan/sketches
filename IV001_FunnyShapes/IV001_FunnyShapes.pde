int numberOfSides = 3;
int radius = 135;
int pointsPerSide = 20;

Shape shape;

PShader grainShader;

String[] palettes = {
  "3d5a80-98c1d9",
  "ffbc42-d81159",
  "4464ad-a4b0f5",
  "50ffb1-4fb286",
  "fcefef-7fd8be",
  "e4fde1-8acb88",
  "ffe74c-ff5964",
  "f5f5f5-33ccff",
  "e5f9e0-a3f7b5",
};

color stringToColor(String hex) {
  String r = hex.substring(0, 2);
  String g = hex.substring(2, 4);
  String b = hex.substring(4, 6);

  colorMode(RGB, 255.0, 255.0, 255.0);
  color c = color(unhex(r), unhex(g), unhex(b));

  return c;
}

color[] paletteToColors(String palette) {
  String[] hexCodes = palette.split("-");

  color[] colors = new color[hexCodes.length];

  for(int i=0; i<hexCodes.length; i++) {
    colors[i] = stringToColor(hexCodes[i]);
  }

  return colors;
}

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

  color[] palette = paletteToColors(palettes[(frameCount + 6) % palettes.length]);

  shape = new Shape(frameCount + 2, 4.0 * 3.14159 / (frameCount + 2), radius, max(10, 60 - frameCount), palette[0], palette[1]);
  shape.draw(-28, -28);


  saveFrame("frames_7/###.png");
}
