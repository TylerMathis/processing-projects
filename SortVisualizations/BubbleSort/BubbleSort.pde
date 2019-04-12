int buffer = 50;
int i, j;

Collection collection;

void setup()
{
  size(displayWidth, displayHeight);
  background(0);
  
  collection = new Collection(50);
  collection.generateValues();
  collection.drawValues();
  
  i = 0;
  j = 0;
}

void draw()
{
    
  
  if (millis() > buffer)
  {
    j++;
    if (j >= collection.size - i - 1)
    {
      j = 0;
      i++;
    }
    if (i < collection.size - 1)
      collection.incrementBubbleSort(j);
  }
}
