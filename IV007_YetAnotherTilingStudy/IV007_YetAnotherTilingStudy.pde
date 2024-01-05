PShader tilingShader;
PImage noiseTexture;

String[] palettes = {
  "b8b42d-697a21-fffce8-3e363f-dd403a",
  "c03221-f7f7ff-f2d0a4-545e75-3f826d",
  "984447-add9f4-476c9b-468c98-101419",
  "3a3042-db9d47-ff784f-ffe19c-edffd9",
  "d00000-ffba08-3f88c5-032b43-136f63",
  "d7263d-f46036-2e294e-1b998b-c5d86d",
  "80a1c1-eee3ab-d9cfc1-a77e58-ba3f1d",
  "f4f7be-e5f77d-deba6f-823038-1e000e",
  "f8ffe5-06d6a0-1b9aaa-ef476f-ffc43d",
  "28262c-998fc7-d4c2fc-f9f5ff-14248a",
  "2e4057-66a182-caffb9-aef78e-c0d461",
  "4c1e4f-b5a886-fee1c7-fa7e61-f44174",
  "db2763-b0db43-12eaea-bce7fd-c492b1",
  "192a51-f5e6e8-d5c6e0-aaa1c8-967aa1",
  "ffffea-ff5e5b-d8d8d8-00cecb-ffed66",
  "280000-fdffff-b10f2e-570000-de7c5a",
  "7b2d26-19535f-0b7a75-d7c9aa-f0f3f5",
  "143109-aaae7f-d0d6b3-f7f7f7-efefef",
  "3b1f2b-db162f-dbdfac-5f758e-383961",
  "011627-ff3366-2ec4b6-f6f7f8-20a4f3",
  "ffd9da-ea638c-89023e-30343f-1b2021",
  "bbbe64-eaf0ce-c0c5c1-7d8491-443850",
  "ffffff-12355b-420039-d72638-ff570a",
  "1c0b19-140d4f-4ea699-2dd881-6fedb7",
  "16bac5-171d1c-5fbff9-efe9f4-5863f8"
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

  tilingShader = loadShader("tiling.frag");
  noiseTexture = loadImage("texture_32_8.png");

  tilingShader.set("iResolution", 1080.0, 1080.0);
  tilingShader.set("iChannel0", noiseTexture);
}

void draw() {
  tilingShader.set("iTime", (float) frameCount);

  color[] palette = paletteToColors(palettes[(((frameCount + 1) / 2) - 1) % palettes.length]);

  float[] bg_color = colorTo01RgbArray(palette[0]);
  float[] fg_color_1 = colorTo01RgbArray(palette[1]);
  float[] fg_color_2 = colorTo01RgbArray(palette[2]);
  float[] fg_color_3 = colorTo01RgbArray(palette[3]);
  float[] fg_color_4 = colorTo01RgbArray(palette[4]);

  tilingShader.set("bg_color", bg_color, 3);
  tilingShader.set("fg_color_1", fg_color_1, 3);
  tilingShader.set("fg_color_2", fg_color_2, 3);
  tilingShader.set("fg_color_3", fg_color_3, 3);
  tilingShader.set("fg_color_4", fg_color_4, 3);

  rect(0, 0, width, height);

  shader(tilingShader);

  saveFrame("frames_1/###.png");

  if(frameCount >= palettes.length * 2) {
    exit();
  }
}
