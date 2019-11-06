// holds all curves
ArrayList<CurveInstance> curves = new ArrayList<CurveInstance>();

// booleans to hold some movement and mouse states
boolean moving = false;
boolean mouseNotReleased = false;
boolean keyboardInp = false;
boolean keyNotHeld = true;
boolean negative = false;

// index of a moving curve
int targettedCurve;

// override if necessary
int globalSmooth = 100;

// how many grid lines do we want?
int gridX = 40;
int gridY = 20;

// hold inpX and inpY values
int inpX = 0;
int inpY = 0;

// first enter for keyboard input
boolean firstEnter = true;

void setup()
{
  size(1400, 800);
  drawScene();
}

void draw()
{
  checkAndHandleMouse();
}

// check the click, and see if its valid
// move the clicked point if so
void checkAndHandleMouse()
{
  if (mousePressed && !mouseNotReleased)
  {
    mouseNotReleased = true;

    boolean validMove = false;
    if (moving)
    {
      moving = !moving;
    } else
    {
      for (int curve = 0; curve < curves.size(); curve++)
      {
        if (curves.get(curve).startMove())
        {
          if (keyPressed)
            if (key == 'p')
            {
              print("keyboardInp\n");
              keyboardInp = true;
            }
          validMove = true;
          moving = true;
          targettedCurve = curve;
        }
      }
      if (!validMove)
        curves.add(new CurveInstance(new PVector(mouseX, mouseY), globalSmooth));
    }
  }
  if (moving)
  {

    // keyabord management
    if (keyboardInp)
    {
      if (keyPressed && keyNotHeld)
      {
        keyNotHeld = false;
        if (int(key) == 45)
          negative = true;
        if (int(key) >= 48 && int(key) <= 57)
        {
          if (firstEnter)
          {
            inpX *= 10;
            inpX += int(key) - 48;
            print("\n\n\n\n\n\n", inpX);
          } else
          {
            inpY *= 10;
            inpY += int(key) - 48;
            print("\n\n\n\n\n\n", inpY);
          }
        } else if (key == 10)
        {
          print("ENTER PRESSED\n");
          if (firstEnter)
          {
            if (negative)
            {
              inpX = -inpX;
              negative = false;
            }
            firstEnter = false;
          } else
          {
            if (negative)
              inpY = -inpY;
            firstEnter = true;
            curves.get(targettedCurve).movePoint(convScreenSpace(inpX, inpY));
            inpX = 0;
            inpY = 0;
            drawScene();
            keyboardInp = false;
            moving = false;
          }
        }
      }
    } else
    {
      curves.get(targettedCurve).movePoint(new PVector(mouseX, mouseY));
      //  redraw curves
      drawScene();
    }
  }
}

// draw background, grid, and curves
void drawScene()
{
  background(255);
  float stepX = width / gridX;
  float stepY = height / gridY;

  stroke(150);
  strokeWeight(1);

  for (int x = 0; x <= width; x += stepX)
    line(x, 0, x, height);

  for (int y = 0; y <= height; y += stepY)
    line(0, y, width, y);

  stroke(0);
  line(width / 2, 0, width / 2, height);
  line(0, height / 2, width, height / 2);

  for (int curve = 0; curve < curves.size(); curve++)
    curves.get(curve).drawCurve();
}

void mouseReleased()
{
  mouseNotReleased = false;
}

void keyReleased()
{
  keyNotHeld = true;
}

PVector convScreenSpace(int locX, int locY)
{
  float convX = width / gridX;
  float convY = height / gridY;
  float xUnitToPx = locX * convX;
  float yUnitToPx = locY * convY;

  return new PVector(width / 2.0 + xUnitToPx, height / 2.0 - yUnitToPx);
}
