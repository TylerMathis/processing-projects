class Collection
{
  private int size;
  private int speed;
  ArrayList<Integer> collection = new ArrayList<Integer>();

  int cellSize;

  Collection(int size, int speed)
  {
    this.size = size;
    this.speed = speed;

    cellSize = width/size;
  }

  public void generateValues()
  {
    for (int i = 0; i < size; i++)
    {
      collection.add((int)random(0, 100));
    }
  }

  public void drawValues()
  {
    background(0);
    for (int i = 0; i < size; i++)
    {
      colorMode(HSB, 100);
      fill(collection.get(i), 100, 100);
      rect(i * cellSize, height, cellSize, -collection.get(i) * (height / 100) - 100);
    }
  }

  public void incrementBubbleSort(int j)
  {
    if (collection.get(j) > collection.get(j + 1))
    {
      Integer temp = collection.get(j);
      collection.set(j, collection.get(j + 1));
      collection.set(j + 1, temp);
      this.drawValues();
    }
  }
}
