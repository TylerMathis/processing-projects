void setup()
{
  size(510, 510);
  
  for (int r = 0; r < 510; r+=2)
  {
    for (int g = 0; g < 510; g+=2)
    {
      fill(r / 2, g / 2, 100);
      rect(r / 2, g / 2, 2, 2);
    }
  }
}

void draw()
{
}
