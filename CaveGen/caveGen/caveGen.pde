int map[][], mapBuffer[][];
int cellSize = 5;
int percentWall = 50;

int timeBuffer = 100;
int delay = timeBuffer;

void setup()
{
  size(800, 800);
  map = new int[width / cellSize][height / cellSize];
  map = randomizeMap(map);
  drawMap(map);
}

void draw()
{
  if (millis() > timeBuffer)
  {
    map = smoothMap(map);
    drawMap(map);
    timeBuffer += delay;
  }
}

int[][] randomizeMap(int map[][])
{
  for (int i = 0; i < map.length; i++)
  {
     for (int j = 0; j < map[i].length; j++)
     {
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
         fill(map[i][j] == 1? 0: 255);
         rect(i * cellSize, j * cellSize, cellSize, cellSize);
     }
  }
}

int[][] smoothMap(int map[][])
{
  mapBuffer = map;
  int neighbors;
  for (int i = 0; i < map.length; i++)
  {
     for (int j = 0; j < map[i].length; j++)
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
