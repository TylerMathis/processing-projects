class CurveInstance
{
  // hold curve's three points (only 4 for project)
  PVector[] points = new PVector[4];
  // how separated should they start?
  float separation = 150;
  // how smooth should our curve be?
  int smoothness;
  // circle indicators
  int circleSize = 20;
  // moved point
  int movedPoint;

  // constructor lays out curve straight at first
  CurveInstance(PVector startingPos, int _smoothness)
  {
    points[0] = startingPos;
    points[1] = new PVector(points[0].x + separation, points[0].y);
    points[2] = new PVector(points[1].x + separation, points[1].y);
    points[3] = new PVector(points[2].x + separation, points[2].y);

    smoothness = _smoothness;

    fill(0);
    stroke(255, 0, 0);
    drawCurve();
  }

  void movePoint(PVector newLoc)
  {
    points[movedPoint] = newLoc;
    drawCurve();
  }

  // calculate and draw curve
  void drawCurve()
  {
    // calculate step
    float step = 1.0 / smoothness;
    // parametric, so start at 0
    float t = 0;

    // store prev point and next point, for line drawing
    // floats instead of PVectors so they properly dereference
    float prevPointX;
    float prevPointY;
    float nextPointX = points[0].x;
    float nextPointY = points[0].y;

    // draw circles
    drawCircles();

    // prepare colors for line
    stroke(255, 0, 0);
    strokeWeight(1);

    // step through parametric and draw lines
    while (t + step <= 1)
    {
      t += step;
      prevPointX = nextPointX;
      prevPointY = nextPointY;
      nextPointX = (points[0].x * pow(1 - t, 3)) + (3 * points[1].x * t * pow(1 - t, 2)) + (3 * points[2].x * pow(t, 2) * (1 - t)) + (points[3].x * pow(t, 3));
      nextPointY = (points[0].y * pow(1 - t, 3)) + (3 * points[1].y * t * pow(1 - t, 2)) + (3 * points[2].y * pow(t, 2) * (1 - t)) + (points[3].y * pow(t, 3));

      line(prevPointX, prevPointY, nextPointX, nextPointY);
    }
  }

  void drawCircles()
  {
    for (int point = 0; point < points.length; point++)
    {
      noStroke();
      ellipse(points[point].x, points[point].y, circleSize, circleSize);
    }
  }

  // returns false if not on a dot, initiates move and returns true otherwise
  boolean startMove()
  {
    boolean onCircle = false;

    float pointX;
    float pointY;

    for (int point = 0; point < points.length; point++)
    {
      pointX = points[point].x;
      pointY = points[point].y;

      if (pointX - circleSize / 2.0 < mouseX && mouseX < pointX + circleSize / 2
        && pointY - circleSize / 2.0 < mouseY && mouseY < pointY + circleSize / 2)
      {
        onCircle = true;
        movedPoint = point;
      }
    }
    return onCircle;
  } 

  PVector convScreenSpace(PVector loc)
  {
    return new PVector(width / 2.0 + loc.x, height / 2.0 - loc.y);
  }
}
