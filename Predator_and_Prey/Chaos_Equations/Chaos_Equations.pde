int tBuffer = 0;
int tDelay = 100;

float t = 0.25;

int circleSize = 5;

void setup()
{
  size(displayWidth, displayHeight);
  smooth();
  background(0);
}

void draw()
{
  noStroke();
  fill(0, 0, 0, 25);
  rect(0, 0, width, height);
  t += 0.0005; 
  calcPoints(t, 500);
  //saveFrame("images/chaosFn1_#####.png");
}

void calcPoints(float t, int n)
{
  float x = t;
  float y = t;

  for (int i = 0; i < n; i++)
  {
    x = -sq(x) + x * t + sq(y) * t;
    y = sq(x) - sq(y) - sq(t) - x * y + y * t - x + y;
    fill((x*1000) % 155 + 100, (y*1000) % 155 + 100, (x * y * 1000) % 155 + 100);
    ellipse((float)convertX(x*500) - circleSize / 2, (float)convertY(y*500) - circleSize / 2, circleSize, circleSize);
    println("t = " + t + " x: " + x + ", y: " + y + "\n");
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
