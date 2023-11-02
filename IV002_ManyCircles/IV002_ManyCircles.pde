int numberOfCircles = 300;
int minRadius = 100;
int maxRadius = 2000;

PShader grainShader;

String[] palettes = {
  "5f0f40-9a031e-fb8b24-e36414-0f4c5c",
  "ffd35c-fc834a-ff5ca3-a26af1",
  "335c67-fff3b0-e09f3e-9e2a2b",
  "6f2dbd-a663cc-b298dc-b8d0eb",
  "d4e09b-f6f4d2-cbdfbd-f19c79",
  "ff5e5b-d8d8d8-ffffea-00cecb",
  "2660a4-edf7f6-f19953-c47335",
  "4464ad-a4b0f5-f58f29-e15a97",
  "231f20-bb4430-7ebdc2-f3dfa2",
  "a40e4c-2c2c54-acc3a6-f5d6ba",
  "fe5d26-f2c078-faedca-c1dbb3-7ebc89",
  "156064-00c49a-f8e16c-ffc2b4-fb8f67",
  "7d84b2-8e9dcc-d9dbf1-f9f9ed-dbf4a7",
  "2b2d42-92dce5-f8f7f9-f7ec59-ff66d8",
  "def57a-91f5ad-8b9eb7-745296-632a50",
  "987284-75b9be-d0d6b5-f9b5ac-ee7674",
  "efbdeb-b68cb8-6461a0-314cb6-0a81d1",
  "eafdf8-e5e9ec-ddcad9-d1b1cb-7c616c",
  "fcb97d-edd892-c6b89e-b5b8a3-aaba9e",
  "c9cad9-d1d2f9-a3bcf9-7796cb-576490",
  "b8b8f3-d7b8f3-f397d6-f42272-232e21",
  "0d1321-ffeddf-c5d86d-86615c-afe0ce",
  "ceff1a-aaa95a-82816d-414066-1b2d2a",
  "0d1f2d-546a7b-9ea3b0-fae1df-e4c3ad",
  "587291-2f97c1-1ccad8-15e6cd-0cf574",
  "5aff15-aaffe5-9d75cb-a657ae-8c1a6a",
  "22162b-451f55-724e91-e54f6d-f8c630",
  "102542-f87060-cdd7d6-b3a394-ffffff",
  "50ffb1-4fb286-3c896d-546d64-4d685a",
  "baf2bb-baf2d8-bad7f2-f2bac9-f2e2ba",
  "e0acd5-3993dd-f4ebe8-29e7cd-6a3e37",
  "6d545d-756d54-8b9556-abb557-bed558",
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
  background(0);

  int newMaxRadius = maxRadius;

  color[] palette = paletteToColors(palettes[(frameCount) % palettes.length]);

  for(int i=0; i<numberOfCircles; i++) {
    int outerRadius = int(random(minRadius, newMaxRadius));
    int colorIndex = int(floor(random(palette.length)));

    int x = int(floor(random(width)));
    int y = int(floor(random(height)));
    
    noStroke();

    while(outerRadius > 25) {
      fill(palette[colorIndex]);
      colorIndex = (colorIndex + 1) % palette.length;
      ellipse(x, y, outerRadius, outerRadius);
      outerRadius -= 50;
    }

    newMaxRadius -= 1400.0 / numberOfCircles;
  }

  filter(grainShader);

  if(frameCount > 34) exit();

  saveFrame("frames/###.png");
  
}
