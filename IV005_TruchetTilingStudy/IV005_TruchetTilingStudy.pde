PShader truchetShader;

String[] palettes = {
  "171a21-6e8290-92bcea-323948-8c9ba6-bad5f2",
  "ed254e-f9dc5c-f4fffd-f36884-fbea9d-d6fff7",
  "1e3888-47a8bd-f5e663-476bd7-87c6d4-faf3b2",
  "acbea3-40476d-826754-dfe6db-2d324d-564438",
  "084b83-42bfdd-bbe6e4-3fa2f3-bae7f3-4cbdb7",
  "485696-e7e7e7-f9c784-acb4d7-b8b8b8-fef6ec",
  "000000-92dce5-eee5e9-474747-def4f7-f7f3f5",
  "2660a4-edf7f6-f19953-9cbfe8-abd9d4-f7c8a1",
  "3891a6-4c5b5c-fde74c-b3dce6-bcc7c8-fef29a",
  "466365-b49a67-ceb3ab-abc3c4-c9b792-e8dcd8",
  "5b4b49-db93b0-f7bfb4-443836-f0d1dd-fdefed",
  "729ea1-b5bd89-dfbe99-416062-dee2cb-faf5ef",
  "337ca0-9dff70-fffc31-92c4dd-3ab800-e0dd00",
  "37123c-71677c-a99f96-902f9d-ccc7d1-edeae9",
  "70ffdb-6153cc-a60067-00b88a-c5c0ec-ff5cc0",
  "d1faff-9bd1e5-6a8eae-007e8f-cee9f2-d7e1ea",
  "312f2f-84dccf-a6d9f7-1f1e1e-cff2ec-d9effc",
  "2b59c3-253c78-d36582-214497-92a7dd-f2cfd8",
  "c2b2b4-6b4e71-3a4454-ede8e9-5b4360-212730",
  "3581b8-ebe9e9-f3f8f2-204e6f-cfc9c9-e7f1e4",
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

  float[] bg_1 = colorTo01RgbArray(palette[0]);
  float[] line_1 = colorTo01RgbArray(palette[1]);
  float[] circle_1 = colorTo01RgbArray(palette[2]);
  float[] bg_2 = colorTo01RgbArray(palette[3]);
  float[] line_2 = colorTo01RgbArray(palette[4]);
  float[] circle_2 = colorTo01RgbArray(palette[5]);

  truchetShader.set("bg_color_1", bg_1, 3);
  truchetShader.set("bg_color_2", bg_2, 3);
  truchetShader.set("line_color_1", line_1, 3);
  truchetShader.set("line_color_2", line_2, 3);
  truchetShader.set("circle_color_1", circle_1, 3);
  truchetShader.set("circle_color_2", circle_2, 3);

  rect(0, 0, width, height);

  shader(truchetShader);

  saveFrame("frames_5/###.png");

  if(frameCount >= palettes.length * 2) {
    exit();
  }
}
