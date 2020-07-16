// tuning variables
int gridSize = 20;
int dotSize = 10;

// dot diameter
float dangerDotDiameter;

// useful colors
color nicePurple = color(150, 130, 220);
color niceBlue = color(0, 200, 197);

// windowSize
int numCells = 40;

// iteration tracker
int iteration = 0;

// arraylist to hold dots
ArrayList<Dot> dots = new ArrayList<Dot>();

// hold already processed collisions
ArrayList<Integer> collidedIndices = new ArrayList<Integer>();

void setup()
{
  background(nicePurple);
  size(1920, 1080);
  
  noStroke();
  
  dangerDotDiameter = 2 * gridSize * sqrt(2);
  
  //drawGrid();
}

void draw()
{
  if (iteration < 500)
    placeDot();
  else
  {
    background(nicePurple);
    moveDot();
  }
}

void placeDot()
{
  int rx, ry;
  float rvx, rvy;
  
  rx = int(random(dotSize / 2, width - dotSize / 2));
  ry = int(random(dotSize / 2, height - dotSize / 2));
  
  rvx = random(-5, 5);
  rvy = random(-5, 5);
  
  boolean valid = checkValidity(rx, ry);
   
  if (valid)
  {
    boolean specialDot = (iteration == 0)? true: false;
    Dot newDot = new Dot(rx, ry, rvx, rvy, dotSize, specialDot);
    newDot.drawDot();
    dots.add(newDot);
  }
  
  iteration++;
}

boolean checkValidity(int rx, int ry)
{
  for (int i = 0; i < dots.size(); i++)
  {
    float diffX, diffY;
    diffX = rx - dots.get(i).x;
    diffY = ry - dots.get(i).y;
    if (sqrt(diffX * diffX + diffY * diffY) <= dangerDotDiameter / 2)
      return false;
  }
  return true;
}

void moveDot()
{
  for (int i = 0; i < dots.size(); i++)
  {
    checkCollisions(i);
    dots.get(i).move();
    dots.get(i).drawDot();
  }
  collidedIndices.clear();
}

void checkCollisions(int index)
{
  float dx = dots.get(index).x;
  float dy = dots.get(index).y;
  
  // if wall collision found
  if (dx <= dotSize / 2 || dx >= width - dotSize / 2 || dy <= dotSize / 2 || dy >= height - dotSize / 2)
  {
    // check if its left or right
    if (dx <= dotSize / 2 || dx >= width - dotSize / 2)
      dots.get(index).changeV(-dots.get(index).vx, dots.get(index).vy);
    // check if its top or bottom
    if (dy <= dotSize / 2 || dy >= height - dotSize / 2)
      dots.get(index).changeV(dots.get(index).vx, -dots.get(index).vy);
    return;
  }
    
  // if we have collided
  if (collidedIndices.contains(index))
    return;
    
  for (int i = 0; i < dots.size(); i++)
  {
    if (i != index)
    {
      float diffX, diffY;
      diffX = dx - dots.get(i).x;
      diffY = dy - dots.get(i).y;
      if (sqrt(diffX * diffX + diffY * diffY) <= dotSize)
      {
        float oldVX = dots.get(index).vx;
        float oldVY = dots.get(index).vy;
        dots.get(index).changeV(dots.get(i).vx, dots.get(i).vy);
        dots.get(i).changeV(oldVX, oldVY);

        collidedIndices.add(index);
        collidedIndices.add(i);

        return;
      }
    }
  }
}

void drawGrid()
{ 
  for (int i = 0; i < numCells; i++)
    for (int j = 0; j < numCells; j++)
      rect(i * gridSize, j * gridSize, gridSize, gridSize);
}
