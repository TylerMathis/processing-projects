ArrayList<CurveInstance> curves = new ArrayList<CurveInstance>();

boolean moving = false;
int targettedCurve;

void setup()
{
  size(1400, 800);
  background(255);
}

void draw()
{
  if (mousePressed)
  {
    boolean validMove = false;
    if (moving)
    {
      moving = !moving;
      curves.get(targettedCurve).movePoint(new PVector(mouseX, mouseY));

      //  redraw curves
      background(255);
      for (int curve = 0; curve < curves.size(); curve++)
        curves.get(curve).drawCurve();
    } else
    {
      for (int curve = 0; curve < curves.size(); curve++)
      {
        if (curves.get(curve).startMove())
        {
          validMove = true;
          moving = true;
          targettedCurve = curve;
        }
      }
      if (!validMove)
        curves.add(new CurveInstance(new PVector(mouseX, mouseY), 100));
    }
  }
}
