int numberOfLines = 16;
int verticesPerLine = 16 + 2;

float maxYOffset = 25.0;

PShader grainShader;

// Three colors, first one is background, other two are line colors interpolated
String[] palettes = {
  "340068-ff6978",
  "d72638-3f88c5",
  "750d37-b3dec1", // dont
  "050609-f5d0c5",
  "b2aa8e-0c1b33",
  "233d4d-fe7f2d",
  "f6bd60-f7ede2",
  "0a122a-698f3f",
  "ec0b43-58355e",
  "b8336a-c490d1",
  "8e5572-f2f7f2",
  "fdffff-b10f2e",
  "272838-f3de8a",
  "ffbc42-d81159",
  "e9d758-297373",
  "eeeeff-7f7caf",
  "1c3144-d00000",
  "ffffff-81f4e1",
  "340068-ff6978",
  "363537-ef2d56",
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

  grainShader = loadShader("grain.frag");
}

void draw() {
  color[] palette = paletteToColors(palettes[(frameCount) % palettes.length]);
  
  background(palette[0]);
  noStroke();

  float[][] y = new float[numberOfLines][verticesPerLine];

  for(int i=0; i<numberOfLines; i++) {
    y[i][0] = height * (i) / (numberOfLines);
    y[i][verticesPerLine - 1] = y[i][0];

    float lineMaxOffset = lerp(0, maxYOffset, (float)(i) / (float)(numberOfLines - 1.0));

    for(int j=1; j<verticesPerLine-1; j++) {
      y[i][j] = y[i][0] + lineMaxOffset * constrain(randomGaussian(), -1, 1);
    }
  }

  for(int i=0; i<numberOfLines; i++) {
    fill(lerpColor(palette[0], palette[1], (float)(i) / (float)(numberOfLines - 1.0))); 

    beginShape();
    curveVertex(0, y[i][0]);
    for(int j=0; j<verticesPerLine; j++) {
      curveVertex(width * (float)(j) / (verticesPerLine - 1.0), y[i][j]);
    }
    curveVertex(width, y[i][verticesPerLine - 1]);
    vertex(width, height);
    vertex(0, height);
    vertex(0, y[i][0]);
    endShape();
  }

  filter(grainShader);

  saveFrame("frames_2/###.png");

  if(frameCount >= palettes.length) exit();
}
