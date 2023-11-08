float tilesPerWidth = 10.0;
float tileSize;

PImage[] tiles;

PShader colors;

String pathName = "";

String[] palettes = {
  "5F4BB6-433582",
  "7E6EC4-433582",
  "988BD0-433582",
  "d72638-3f88c5",
  "750d37-b3dec1",
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

float[] colorTo01RgbArray(color c) {
  colorMode(RGB, 1.0, 1.0, 1.0);

  float[] rgbArray = new float[3];
  rgbArray[0] = red(c);
  rgbArray[1] = green(c);
  rgbArray[2] = blue(c);

  return rgbArray;
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");

    exit();
  } else {
    println("User selected " + selection.getAbsolutePath());

    pathName = selection.getName();
    
    File[] files = selection.listFiles();

    int fileCount = files.length;

    tiles = new PImage[fileCount];
    
    int i = 0;
    for(File file : files) {
      println("File: " + file.getAbsolutePath());
      
      tiles[i] = loadImage(file.getAbsolutePath());
      i++;
    }

    loop();
  }
}

void setup() {
  size(1080, 1080, P2D);

  selectFolder("Select a folder with tile images:", "folderSelected");

  colors = loadShader("colors.frag");

  tileSize = width / tilesPerWidth;

  frameRate(1);

  noLoop();
}

void draw() {
  background(255);

  if(tiles != null) {
    color[] palette = paletteToColors(palettes[(frameCount - 1) % palettes.length]);

    colorMode(RGB, 1.0, 1.0, 1.0);
    float[] color_1 = colorTo01RgbArray(palette[0]);
    float[] color_2 = colorTo01RgbArray(palette[1]);


    colors.set("color_1", color_1, 3);
    colors.set("color_2", color_2, 3);

    for(float x = 0.0; x < width; x += tileSize) {
      for(float y = 0.0; y < height; y += tileSize) {
        float rnd = random(0.0, 1.0);

        for(int i = 0; i < tiles.length; i++) {
          if(rnd <= (i + 1) * (1.0 / (float) tiles.length)) {
            image(tiles[i], x, y, tileSize, tileSize);
            break;
          }
        }
      }
    }

    filter(colors);

    saveFrame("frames_" + pathName + "/###.png");

    if(frameCount >= palettes.length) exit();
  }
}
