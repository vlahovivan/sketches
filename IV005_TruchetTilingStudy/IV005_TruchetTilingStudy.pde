PShader truchetShader;

String[] palettes = {
  "171a21-6e8290-92bcea",
  "ed254e-f9dc5c-f4fffd",
  "1e3888-47a8bd-f5e663",
  "acbea3-40476d-826754",
  "084b83-42bfdd-bbe6e4",
  "485696-e7e7e7-f9c784",
  "000000-92dce5-eee5e9",
  "2660a4-edf7f6-f19953",
  "3891a6-4c5b5c-fde74c",
  "466365-b49a67-ceb3ab",
  "5b4b49-db93b0-f7bfb4",
  "729ea1-b5bd89-dfbe99",
  "337ca0-9dff70-fffc31",
  "37123c-71677c-a99f96",
  "70ffdb-6153cc-a60067",
  "d1faff-9bd1e5-6a8eae",
  "312f2f-84dccf-a6d9f7",
  "2b59c3-253c78-d36582",
  "c2b2b4-6b4e71-3a4454",
  "3581b8-ebe9e9-f3f8f2",
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

float[] colorTo01RgbArray(color c) {
  colorMode(RGB, 1.0, 1.0, 1.0);

  float[] rgbArray = new float[3];
  rgbArray[0] = red(c);
  rgbArray[1] = green(c);
  rgbArray[2] = blue(c);

  return rgbArray;
}

void setup() {
  size(1080, 1080, P2D);

  truchetShader = loadShader("truchet.frag");

  truchetShader.set("iResolution", 1080.0, 1080.0);
}

void draw() {
  truchetShader.set("iTime", (float) frameCount);

  color[] palette = paletteToColors(palettes[(((frameCount + 1) / 2) - 1) % palettes.length]);

  float[] bg = colorTo01RgbArray(palette[0]);
  float[] line = colorTo01RgbArray(palette[1]);
  float[] circle = colorTo01RgbArray(palette[2]);

  truchetShader.set("bg_color_1", bg[0], bg[1], bg[2]);
  truchetShader.set("bg_color_2", bg[0], bg[1], bg[2]);
  truchetShader.set("line_color_1", line[0], line[1], line[2]);
  truchetShader.set("line_color_2", line[0], line[1], line[2]);
  truchetShader.set("circle_color_1", circle[0], circle[1], circle[2]);
  truchetShader.set("circle_color_2", circle[0], circle[1], circle[2]);

  // noFill();
  // noStroke();

  rect(0, 0, width, height);

  shader(truchetShader);

  saveFrame("frames/###.png");

  if(frameCount >= palettes.length * 2) {
    exit();
  }
}
