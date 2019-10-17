int cellSize;

int cellsX;
int cellsY;

int[][] cells;
int[][] cellsBuffer;

int percentChanceWhite;

int buffer;
int bufferDelay;

boolean calculating = true;

int paintedCellX;
int paintedCellY;

void setup() {
  background(0);  
  size(displayWidth, displayHeight);

  cellSize = 20;

  percentChanceWhite = 15;

  buffer = 400;
  bufferDelay = 25;

  cellsX = width / cellSize;
  cellsY = (height / cellSize) - 5;
  
  paintedCellX = 0;
  paintedCellY = 0;

  cells = new int[cellsX][cellsY];
  cellsBuffer = new int[cellsX][cellsY];

  drawMenu();
  populateCells();
}

void draw() {
  if (millis() > buffer) {
    if (calculating == true) {
      drawCells();
      calculateCells();
      buffer = millis() + bufferDelay;
    }
  }
}

void mousePressed() {
  if (mouseX < width / 2 && mouseY > height - cellSize * 5) {
    calculating = true;
  } else if (mouseX > width / 2 && mouseY > height / cellSize - 5) {
    calculating = false;
  }
  
  if (calculating == false) {
    paintedCellX = mouseX / cellSize;
    paintedCellY = mouseY / cellSize;
    
    if (paintedCellY < height / cellSize - 5) {
      paintCell(paintedCellX, paintedCellY);
    }
    
    print ("\nClicked cell array index: " + paintedCellX + ", " + paintedCellY);
  }
}

void paintCell(int indexX, int indexY) {
  if (cells[indexX][indexY] == 0) {
    cells[indexX][indexY] = 1;
    fill(250, 100, 200);
    rect(indexX * cellSize, indexY * cellSize, cellSize, cellSize);

  } else {
    cells[indexX][indexY] = 0;
    fill(0);
    rect(indexX * cellSize, indexY * cellSize, cellSize, cellSize);
  }
}

void drawMenu() {
  fill(0, 255, 0);
  rect(0, height - cellSize * 5, width / 2, cellSize * 5);
  fill(255, 0, 0);
  rect(width / 2, height - cellSize * 5, width / 2, cellSize * 5);
}

void populateCells() {
  print("Starting board state: \n");
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {
      int random = (int(random(0, 100)));
      if (random < percentChanceWhite) {
        cells[i][j] = 1;
      } else {
        cells[i][j] = 0;
      }
      print(cells[i][j] + " ");
    }
    print("\n");
  }
}

void drawCells() {
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {
      if (cells[i][j] == 1) {
        fill(255, 100, 200);
      } else {
        fill(0);
      }
      rect(i * cellSize, j * cellSize, cellSize, cellSize);
    }
  }
}

void calculateCells() {
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {

      int neighbors = checkNeighbors(i, j);

      if (cells[i][j] == 1) {
        if (neighbors < 2 || neighbors > 3) {
          cellsBuffer[i][j] = 0;
        } else {
          cellsBuffer[i][j] = 1;
        }
      } else {
        if (neighbors == 3) {
          cellsBuffer[i][j] = 1;
        } else {
          cellsBuffer[i][j] = 0;
        }
      }
    }
  }
  transferBuffer();
}

int checkNeighbors(int x, int y) {
  int neighbors = 0;
  for (int dx = x-1; dx <= x+1; dx++) {
    for (int dy = y-1; dy <= y+1; dy++) {
      if (dx >= 0 && dx < cellsX && dy >= 0 && dy < cellsY && !(dx == x && dy == y)) {
        if (cells[dx][dy] == 1) {
          neighbors++;
        }
      }
    }
  }
  return neighbors;
}

void transferBuffer() {
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {
      cells[i][j] = cellsBuffer[i][j];
    }
  }
}
