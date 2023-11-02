int numberOfLines = 32;
int verticesPerLine = 32 + 2;

float maxYOffset = 25.0;

// Three colors, first one is background, other two are line colors interpolated
String[] palettes = {
  "f5dfbb-562c2c-f2542d",
  "ef476f-ffd166-06d6a0",
  "e0f2e9-ceb5a7-a17c6b",
  "d3f8e2-e4c1f9-f694c1",
  "042a2b-5eb1bf-54f2f2",
  "2e294e-efbcd5-be97c6",
  "ff5e5b-d8d8d8-ffffea",
  "210124-750d37-b3dec1",
  "0d0106-3626a7-657ed4",
  "d3d4d9-4b88a2-bb0a21",
  "90f1ef-ffd6e0-ffef9f",
  "8e5572-f2f7f2-c2b97f",
  "f45b69-f6e8ea-22181c",
  "faa916-fbfffe-6d676e",
  "dad2d8-143642-0f8b8d",
  "413c58-a3c4bc-bfd7b5",
  "231123-82204a-558c8c",
  "d72638-3f88c5-f49d37",
  "12130f-5b9279-8fcb9b",
  "23ce6b-272d2d-f6f8ff",
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
  smooth(4);
}

void draw() {
  color[] palette = paletteToColors(palettes[(frameCount) % palettes.length]);
  
  background(palette[0]);
  noFill();

  float[][] y = new float[numberOfLines][verticesPerLine];

  for(int i=0; i<numberOfLines; i++) {
    y[i][0] = height * (i + 1) / (numberOfLines + 1.0);
    y[i][verticesPerLine - 1] = y[i][0];

    float lineMaxOffset = lerp(0, maxYOffset, (float)(i) / (float)(numberOfLines - 1.0));

    for(int j=1; j<verticesPerLine-1; j++) {
      y[i][j] = y[i][0] + lineMaxOffset * constrain(randomGaussian(), -1, 1);
    }
  }

  for(int i=0; i<numberOfLines; i++) {
    strokeWeight(2.5 + 5.0 * (float)(i) / (float)(numberOfLines - 1.0));
    stroke(lerpColor(palette[1], palette[2], (float)(i) / (float)(numberOfLines - 1.0))); 

    beginShape();
    curveVertex(0, y[i][0]);
    for(int j=0; j<verticesPerLine; j++) {
      curveVertex(width * (float)(j) / (verticesPerLine - 1.0), y[i][j]);
    }
    curveVertex(width, y[i][verticesPerLine - 1]);
    endShape();
  }

  // saveFrame("frames_3/###.png");

  if(frameCount >= palettes.length) exit();
}
