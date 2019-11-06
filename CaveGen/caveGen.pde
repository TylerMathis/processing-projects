int map[][], mapBuffer[][];
int cellSize = 40;
int percentWall = 47;

int timeBuffer = 1000;
int delay = timeBuffer;

int smoothness = 5;

void setup()
{
  size(800, 800);
  map = new int[height / cellSize][width / cellSize];
  map = randomizeMap(map);
  background(255);
  fill(0);
  noStroke();

  for (int i = 0; i < smoothness; i++)
  {
    map = smoothMap(map);
    timeBuffer += delay;
    if (i == smoothness - 1)
    {
      marchingSquares(map);
      //drawMap(map);
    }
  }
}

void draw()
{
}

int[][] randomizeMap(int map[][])
{
  map = fillEdges(map);
  for (int y = 2; y < map.length - 2; y++)
    for (int x = 2; x < map[y].length - 2; x++)
      map[y][x] = (int(random(100)) <= percentWall? 1: 0);
  return map;
}

void drawMap(int map[][])
{
  for (int y = 0; y < map.length; y++)
    for (int x = 0; x < map[y].length; x++)
      if (map[y][x] == 1)
        rect(x * cellSize, y * cellSize, cellSize, cellSize);
}

int[][] smoothMap(int map[][])
{
  mapBuffer = new int[width / cellSize][height / cellSize];
  mapBuffer = fillEdges(mapBuffer);
  int neighbors;

  for (int y = 1; y < map.length - 1; y++)
    for (int x = 1; x < map[y].length - 1; x++)
    {
      neighbors = getNeighbors(map, y, x);
      if (neighbors > 4)
        mapBuffer[y][x] = 1;
      else if (neighbors < 4)
        mapBuffer[y][x] = 0;
      else
        mapBuffer[y][x] = map[y][x];
    }
  return mapBuffer;
}

int getNeighbors(int[][] map, int y, int x)
{
  int neighbors = 0;
  for (int yDiv = y - 1; yDiv <= y + 1; yDiv++)
    for (int xDiv = x - 1; xDiv <= x + 1; xDiv++)
      if (yDiv >= 0 && yDiv < map.length && xDiv >= 0 && xDiv < map[yDiv].length)
        if (!(yDiv == y && xDiv == x))
          neighbors += map[yDiv][xDiv];
  return neighbors;
}

int[][] fillEdges(int map[][])
{
  for (int y = 0; y < map.length; y++)
  {
    map[y][0] = 1;
    map[y][1] = 1;
    map[y][map[y].length - 1] = 1;
    map[y][map[y].length - 2] = 1;
  }
  for (int x = 0; x < map[0].length; x++)
  {
    map[0][x] = 1;
    map[1][x] = 1;
    map[map.length - 1][x] = 1;
    map[map.length - 2][x] = 1;
  }
  return map;
}

void marchingSquares(int[][] map)
{
  int cellState;
  // for each cell
  for (int yCell = 0; yCell < map.length - 1; yCell++)
    for (int xCell = 0; xCell < map[yCell].length - 1; xCell++)
    {
      // get cell states
      cellState = 2;
      cellState *= 10;
      cellState += map[yCell][xCell];
      cellState *= 10;
      cellState += map[yCell][xCell + 1];
      cellState *= 10;
      cellState += map[yCell + 1][xCell + 1];
      cellState *= 10;
      cellState += map[yCell + 1][xCell];
      print("(x,y):", xCell, ",", yCell, "cellState: ", cellState, "\n");
      // drawCellState(cellState, yCell, xCell);
    }
}

void drawCellState(int cellState, int y, int x)
{
  switch (cellState) {
    // nothing
  case 20000: 
    break;
    // full square
  case 21111: 
    rect(x * cellSize, y * cellSize, cellSize * 2, cellSize * 2);
    break;
    // full up right
  case 21110: 
    rect(x * cellSize, y * cellSize, cellSize * 2, cellSize * 2);
    fill(255);
    triangle(x * cellSize, y * cellSize + cellSize, 
      x * cellSize + cellSize, y * cellSize + cellSize * 2, 
      x * cellSize, y * cellSize + cellSize * 2);
    fill(0);
    break;
    // full up left
  case 21101: 
    rect(x * cellSize, y * cellSize, cellSize * 2, cellSize * 2);
    fill(255);
    triangle(x * cellSize + cellSize * 2, y * cellSize + cellSize, 
      x * cellSize + cellSize * 2, y * cellSize + cellSize * 2, 
      x * cellSize + cellSize, y * cellSize + cellSize * 2);
    fill(0);
    break;
    // full down left
  case 21011: 
    rect(x * cellSize, y * cellSize, cellSize * 2, cellSize * 2);
    fill(255);
    triangle(x * cellSize + cellSize, y * cellSize, 
      x * cellSize + cellSize * 2, y * cellSize, 
      x * cellSize + cellSize * 2, y * cellSize + cellSize);
    fill(0);
    break;
    // full down right
  case 20111: 
    rect(x * cellSize, y * cellSize, cellSize * 2, cellSize * 2);
    fill(255);
    triangle(x * cellSize, y * cellSize, 
      x * cellSize + cellSize, y * cellSize, 
      x * cellSize, y * cellSize + cellSize);
    fill(0);
    break;
    // bottom left
  case 20001: 
    triangle(x * cellSize, y * cellSize + cellSize, 
      x * cellSize + cellSize, y * cellSize + cellSize * 2, 
      x * cellSize, y * cellSize + cellSize * 2);
    // bottom right
  case 20010: 
    triangle(x * cellSize + cellSize * 2, y * cellSize + cellSize, 
      x * cellSize + cellSize * 2, y * cellSize + cellSize * 2, 
      x * cellSize + cellSize, y * cellSize + cellSize * 2);
    // top right
  case 20100: 
    triangle(x * cellSize + cellSize, y * cellSize, 
      x * cellSize + cellSize * 2, y * cellSize, 
      x * cellSize + cellSize * 2, y * cellSize + cellSize);
    // top left
  case 21000: 
    triangle(x * cellSize, y * cellSize, 
      x * cellSize + cellSize, y * cellSize, 
      x * cellSize, y * cellSize + cellSize);
  default:  
    print("Improper cellState format: ", cellState, "\n");
    break;
  }
}
