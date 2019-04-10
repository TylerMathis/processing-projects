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
  
  i = collection.size - 1;
  j = 0;
}

void draw()
{
    
  
  if (millis() > buffer)
  {    
    if (j == i)
    {
      collection.swap(i);
      j = 0;
      i--;
    }
    if (j < i);
    {
      collection.incrementSelectionSort(j);
      j++;
    }
  }
}
