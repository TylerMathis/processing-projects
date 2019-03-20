Ball ball;

boolean newGame = true;

int goalSize = 200;
int goalWidth = 10;

int goalStart;

void setup()
{
  size(800, 800);
  ball = new Ball(50, color(255), 2, 2);
}

void draw()
{
  if(newGame)
  {
    newGoal();
    newGame = false;
  }
  background(0);
  dispGoal();
  ball.move();
  ball.disp();
}

void newGoal()
{
  int lowerBound = 0;
  int upperBound = height - goalSize;
  
  float rand = random(1);
  
  goalStart = (int)map(rand, 0, 1, lowerBound, upperBound);
}

void dispGoal()
{
  fill(0, 255, 0);
  rect(width - (goalWidth + 5), goalStart, goalWidth, goalSize);
}
