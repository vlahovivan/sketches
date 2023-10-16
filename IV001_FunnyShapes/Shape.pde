import java.util.Collections;

class Shape {
  private int numberOfSides;
  private float radius;
  
  private int pointsPerSide;
  
  ArrayList<PVector> vertices = new ArrayList<PVector>();
  ArrayList<PVector> points = new ArrayList<PVector>();

  Shape(int numberOfSides, int radius, int pointsPerSide) {
    this.numberOfSides = numberOfSides;
    this.radius = radius;
    this.pointsPerSide = pointsPerSide;

    // Creating the main vertices of the shape
    for(int i=0; i<numberOfSides; i++) {
      vertices.add(new PVector(radius * cos(i * 2.0 * 3.14159 / (float) numberOfSides), radius * sin(i * 2.0 * 3.14159 / (float) numberOfSides)));
    }

    // Creating the funny points
    for(int i=0; i<numberOfSides; i++) {
      PVector p1 = vertices.get(i);
      PVector p2 = vertices.get((i+1) % numberOfSides);

      for(int j=0; j<pointsPerSide; j++) {
        float t = (float) j / (float) pointsPerSide;

        // Adding some randomness to the t value
        if(j != 0) {
          t += (0.5 / (float) pointsPerSide) * constrain(randomGaussian(), -1.0, 1.0) / 2.0;
        }

        PVector point = PVector.lerp(p1, p2, t);

        // Adding some radial offset to the point
        point.add(PVector.mult(point, (0.3 * constrain(randomGaussian(), -1.0, 1.0))));

        points.add(point);
      }
    }

    // Randomly swapping some values
    for(int i=0; i<pointsPerSide; i++) {
      if(random(1.0) < 0.75) {
        Collections.swap(points, i, (i+1) % points.size());
      }
    }
  }

  void draw(float x, float y) {
    pushMatrix();
    translate(x, y);
    noFill();
    stroke(0);
    strokeWeight(16);

    colorMode(HSB, 360, 100, 100);

    for(int i=0; i<points.size(); i++) {
      PVector p1 = points.get(i);
      PVector p2 = points.get((i+1) % points.size());

      stroke(random(360), 90, 90);
      line(p1.x, p1.y, p2.x, p2.y);
    }

    popMatrix();
  }


}