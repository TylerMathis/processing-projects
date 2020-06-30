import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BezierCurves extends PApplet {

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

public void setup()
{
  
  drawScene();
}

public void draw()
{
  checkAndHandleMouse();
}

// check the click, and see if its valid
// move the clicked point if so
public void checkAndHandleMouse()
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
          {
            if (key == 'p')
            {
              print("keyboardInp\n");
              keyboardInp = true;
              validMove = true;
              moving = true;
              targettedCurve = curve;
            }
            else if (key == 'd')
            {
              validMove = true;
              curves.remove(curve);
              drawScene();
            }
          } else
          {
            validMove = true;
            moving = true;
            targettedCurve = curve;
          }
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
        if (PApplet.parseInt(key) == 45)
          negative = true;
        if (PApplet.parseInt(key) >= 48 && PApplet.parseInt(key) <= 57)
        {
          if (firstEnter)
          {
            inpX *= 10;
            inpX += PApplet.parseInt(key) - 48;
            print("\n\n\n\n\n\n", inpX);
          } else
          {
            inpY *= 10;
            inpY += PApplet.parseInt(key) - 48;
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
public void drawScene()
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

public void mouseReleased()
{
  mouseNotReleased = false;
}

public void keyReleased()
{
  keyNotHeld = true;
}

public PVector convScreenSpace(int locX, int locY)
{
  float convX = width / gridX;
  float convY = height / gridY;
  float xUnitToPx = locX * convX;
  float yUnitToPx = locY * convY;

  return new PVector(width / 2.0f + xUnitToPx, height / 2.0f - yUnitToPx);
}
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

  public void movePoint(PVector newLoc)
  {
    points[movedPoint] = newLoc;
  }

  // calculate and draw curve
  public void drawCurve()
  {
    // calculate step
    float step = 1.0f / smoothness;
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

  public void drawCircles()
  {
    for (int point = 0; point < points.length; point++)
    {
      noStroke();
      ellipse(points[point].x, points[point].y, circleSize, circleSize);
    }
  }

  // returns false if not on a dot, initiates move and returns true otherwise
  public boolean startMove()
  {
    boolean onCircle = false;

    float pointX;
    float pointY;

    for (int point = 0; point < points.length; point++)
    {
      pointX = points[point].x;
      pointY = points[point].y;

      if (pointX - circleSize / 2.0f < mouseX && mouseX < pointX + circleSize / 2
        && pointY - circleSize / 2.0f < mouseY && mouseY < pointY + circleSize / 2)
      {
        onCircle = true;
        movedPoint = point;
      }
    }
    return onCircle;
  } 

  public PVector convScreenSpace(PVector loc)
  {
    float convX = width / gridX;
    float convY = height / gridY;
    float xUnitToPx = loc.x * convX;
    float yUnitToPx = loc.y * convY;
    
    return new PVector(width / 2.0f + xUnitToPx, height / 2.0f - yUnitToPx);
  }
}
  public void settings() {  size(1400, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BezierCurves" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
