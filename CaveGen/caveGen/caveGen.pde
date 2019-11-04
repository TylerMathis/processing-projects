int map[][], mapBuffer[][];
int cellSize = 5;
int percentWall = 47;

int timeBuffer = 1000;
int delay = timeBuffer;

int smoothness = 5;

void setup()
{
  size(1200, 800);
  map = new int[width / cellSize][height / cellSize];
  map = randomizeMap(map);
  drawMap(map);
  fill(0);
}

void draw()
{
  for (int i = 0; i < smoothness; i++)
  {
    background(255);
    map = smoothMap(map);
    drawMap(map);
    timeBuffer += delay;
  }
}

int[][] randomizeMap(int map[][])
{
  map = fillEdges(map);
  for (int i = 0; i < map.length; i++)
  {
     for (int j = 0; j < map[i].length; j++)
     {
       if (i > 1 && i < map.length - 2 && j > 1 && j < map.length - 2)
         map[i][j] = (int(random(100)) <= percentWall? 1: 0);
     }
  }
  return map;
}

void drawMap(int map[][])
{
  for (int i = 0; i < map.length; i++)
  {
     for (int j = 0; j < map[i].length; j++)
     {
         if (map[i][j] == 1)
           rect(i * cellSize, j * cellSize, cellSize, cellSize);
     }
  }
}

int[][] smoothMap(int map[][])
{
  mapBuffer = new int[width / cellSize][height / cellSize];
  mapBuffer = fillEdges(mapBuffer);
  int neighbors;
  for (int i = 1; i < map.length - 1; i++)
  {
     for (int j = 1; j < map[i].length - 1; j++)
     {
       neighbors = getNeighbors(map, i, j);
       if (neighbors > 4)
         mapBuffer[i][j] = 1;
       else if (neighbors < 4)
         mapBuffer[i][j] = 0;
       else
         mapBuffer[i][j] = map[i][j];
     }
  }
  return mapBuffer;
}

int getNeighbors(int[][] map, int i, int j)
{
  int neighbors = 0;
  for (int iDiv = i - 1; iDiv <= i + 1; iDiv++)
  {
     for (int jDiv = j - 1; jDiv <= j + 1; jDiv++)
     {
       if (iDiv >= 0 && iDiv < map.length && jDiv >= 0 && jDiv < map[iDiv].length)
       {
         if (!(iDiv == i && jDiv == j))
         {
           neighbors += map[iDiv][jDiv];
         }
       }
     }
  }
  return neighbors;
}

int[][] fillEdges(int map[][])
{
  for (int i = 0; i < map.length; i++)
  {
    map[i][0] = 1;
    map[i][1] = 1;
    map[i][map[0].length - 1] = 1;
    map[i][map[0].length - 2] = 1;
  }
  for (int j = 0; j < map[0].length; j++)
  {
    map[0][j] = 1;
    map[1][j] = 1;
    map[map.length - 1][j] = 1;
    map[map.length - 2][j] = 1;
  }
  return map;
}
