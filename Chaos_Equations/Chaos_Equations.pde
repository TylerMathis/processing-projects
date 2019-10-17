int tBuffer = 0;
int tDelay = 100;

float t = 0.3;
float speed = 0.1;
int complexity = 500;

int circleSize = 2;

int scale = 1;
int colScale;

float convX, convY;
float x, y;

void setup()
{
  size(displayHeight, displayHeight);
  smooth();
  background(0);
  colScale = width * height;
  colorMode(HSB, colScale);
}

void draw()
{
  noStroke();
  fill(0, 0, 0, 25);
  rect(0, 0, width, height);
  t += speed; 
  calcPoints(t, complexity);
  //saveFrame("images/chaosFn1_#####.png");
}

void calcPoints(float t, int n)
{
  x = t;
  y = t;

  for (int i = 0; i < n; i++)
  {
    //x = -sq(x) + x * t + sq(y) * t;
    //y = sq(x) - sq(t) - x * y + y * t - x + y;
    x = sin(t) * y;
    y = cos(t) * x;
    convX = convertX(x * scale) - circleSize / 2;
    convY = convertY(y * scale) - circleSize / 2;
    if (convX <= width && convX >= 0 && convY <= height && convY >= 0)
    {
      fill(convX * convY, colScale, colScale);
      ellipse(convX, convY, circleSize, circleSize);
    }
  }
}

float convertX(float x)
{
  return x + width / 2;
}

float convertY(float y)
{
  return y + height / 2;
}
