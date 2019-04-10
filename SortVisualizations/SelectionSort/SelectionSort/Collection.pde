class Collection
{
  private int size;
  ArrayList<Integer> collection = new ArrayList<Integer>();

  int cellSize;
  
  int winningIndex;

  Collection(int size)
  {
    this.size = size;

    cellSize = width/size;
    winningIndex = 0;
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
      rect(i * cellSize, height, cellSize, -map(collection.get(i), 0, 100, 0, height));
    }
  }

  public void incrementSelectionSort(int j)
  {
    if (collection.get(j) > collection.get(winningIndex))
      winningIndex = j;
  }
  
  public void swap(int index)
  {
    int temp = collection.get(winningIndex);
    collection.set(winningIndex, collection.get(index));
    collection.set(index, temp);
    drawValues();
  }
}
