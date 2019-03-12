int windowX;
int windowY;

int cellSize;
int cellsX;
int cellsY;

int[] newXY = new int[2];
int newX;
int newY;

int[][] predatorCells;
int[][] preyCells;

int[][] predatorCellsBuffer;
int[][] preyCellsBuffer;

int[][] predatorHealth;
int[][] preyHealth;

int[][] predatorHealthBuffer;
int[][] preyHealthBuffer;

float predatorChance;
float preyChance;

int predatorMaxHealth;
int preyMaxHealth;

float timeDelay;
float timeBuffer;

int preyNumber;
int predatorNumber;

void setup() {
  
  size(1000, 800);
  
  background(0);
  
  // user defined variables here
  cellSize = 10;
  preyChance = 5;
  predatorChance = 5;
  predatorMaxHealth = 25;
  preyMaxHealth = 50;
  
  cellsX = (width-200)/cellSize;
  cellsY = height/cellSize;
  
  fill(255);
  rect(0, 0, width - 200, height);
  
  predatorCells = new int[cellsX][cellsY];
  preyCells = new int[cellsX][cellsY];
  
  predatorCellsBuffer = new int[cellsX][cellsY];
  preyCellsBuffer = new int[cellsX][cellsY];
  
  predatorHealth = new int[cellsX][cellsY];
  preyHealth = new int[cellsX][cellsY];
  
  predatorHealthBuffer = new int[cellsX][cellsY];
  preyHealthBuffer = new int[cellsX][cellsY];

  timeDelay = 0;
  timeBuffer = 500;
 
  initializeCells();
}

void initializeCells() {
  for(int x = 0; x < cellsX; x++) {
    for(int y = 0; y < cellsY; y++) {
      
      int randomNum = int(random(100));
      
      if (randomNum > 0 && randomNum <= predatorChance) {
        predatorCells[x][y] = 1;
        predatorHealth[x][y] = predatorMaxHealth;
      } else if (randomNum > predatorChance && randomNum <= preyChance + predatorChance) {
        preyCells[x][y] = 1;
        preyHealth[x][y] = 0;
      }
    }
  }
}
  
void draw(){
  if(millis() > timeBuffer) {
    calculateCells();
    drawCells();
    timeBuffer += timeDelay;
  }
}

void calculateCells() {
  
  for(int x = 0; x < cellsX; x++) {
    for(int y = 0; y < cellsY; y++) {
      
      // logic if ONLY predator exists
      if(predatorCells[x][y] == 1 && preyCells[x][y] == 0) {
        moveCell(x, y);
        
        newX = newXY[0];
        newY = newXY[1];
        
        if(predatorCellsBuffer[newX][newY] != 1) {
          predatorCellsBuffer[newX][newY] = 1;
          predatorCellsBuffer[x][y] = 0;
          predatorHealthBuffer[newX][newY] = predatorHealth[x][y];
          predatorHealthBuffer[x][y] = 0;
        } else {
            predatorCellsBuffer[x][y] = 1;
            predatorHealthBuffer[x][y] = predatorHealth[x][y];
        }
      }
      
      // logic if ONLY prey exists
      if(preyCells[x][y] == 1 && predatorCells[x][y] == 0) {
        moveCell(x, y);
        newX = newXY[0];
        newY = newXY[1];
 
        if(preyCellsBuffer[newX][newY] != 1) {
          preyCellsBuffer[newX][newY] = 1;
          preyCellsBuffer[x][y] = 0;
          preyHealthBuffer[newX][newY] = preyHealth[x][y];
          preyHealthBuffer[x][y] = 0;
        } else {
            preyCellsBuffer[x][y] = 1;
            preyHealthBuffer[x][y] = preyHealth[x][y];
        }
      }
    } 
  }
  for (int x = 0; x < cellsX; x++) {
    for (int y = 0; y < cellsY; y++) {
      
      // logic if predator AND prey exist AFTER they move
      if(preyCellsBuffer[x][y] == 1 && predatorCellsBuffer[x][y] == 1) {
        preyCellsBuffer[x][y] = 0;
        
        predatorHealthBuffer[x][y] += preyHealthBuffer[x][y];
        if(predatorHealthBuffer[x][y] > predatorMaxHealth)
          predatorHealthBuffer[x][y] = predatorMaxHealth;
        
        moveCell(x, y);
        newX = newXY[0];
        newY = newXY[1];
        
        predatorCellsBuffer[newX][newY] = 1;
        predatorHealthBuffer[newX][newY] = predatorHealthBuffer[x][y];
        preyHealthBuffer[x][y] = 0;
      }
      
      // duplicate prey if heatlh max
      if(preyHealthBuffer[x][y] == preyMaxHealth) {
        moveCell(x, y);
        newX = newXY[0];
        newY = newXY[1];
        
        preyCellsBuffer[newX][newY] = 1;
      }
      
      // update main array to match buffer
      predatorCells[x][y] = predatorCellsBuffer[x][y];
      preyCells[x][y] = preyCellsBuffer[x][y];
      
      predatorHealth[x][y] = predatorHealthBuffer[x][y];
      preyHealth[x][y] = preyHealthBuffer[x][y];
      
      if(predatorHealth[x][y] == 0)
        predatorCellsBuffer[x][y] = 0;
        
      if(predatorHealth[x][y] > 0)
        predatorHealth[x][y]--;
        
      if(preyHealth[x][y] < preyMaxHealth)
        preyHealth[x][y]++;
    }
  }
}

void moveCell(int x, int y) {
  newXY[0] = int(random(x-1, x+2));
  newXY[1] = int(random(y-1, y+2));
  
  if(!(newXY[0] >= 0 && newXY[0] < cellsX && newXY[1] >= 0 && newXY[1] < cellsY)) {
    newXY[0] = x;
    newXY[1] = y;
  }
}

void drawCells() {
  fill(100);
  rect(width-200, 0, 200, height);
  preyNumber = 0;
  predatorNumber = 0;
  for(int x = 0; x < cellsX; x++) {
    for(int y = 0; y < cellsY; y++) {
      if (predatorCells[x][y] == 1) {
        fill(255, 0, 0, predatorHealth[x][y] * 10);
        predatorNumber++;
      }
      else if (preyCells[x][y] == 1) {
        fill(0, 255, 0, preyHealth[x][y] * 10);
        preyNumber++;
      }
      else
        fill(0);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
  fill(255);
  rect(width - 202, 0, 2, height);
  fill(0, 255, 0);
  rect(width - 200, 0, 100, map(preyNumber, 0, cellsX * cellsY / 4, 0, height));
  fill(255, 0, 0);
  rect(width - 100, 0, 100, map(predatorNumber, 0, cellsX * cellsY / 4, 0, height));
}
