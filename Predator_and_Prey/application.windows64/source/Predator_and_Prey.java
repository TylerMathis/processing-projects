import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Predator_and_Prey extends PApplet {

int windowX;
int windowY;

int cellSize;
int cellsX;
int cellsY;

float percentDispData;
int dataPixelWidth;
int cellsPixelWidth;

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

int maxSpeciesCount;
int dataCap;

float timeDelay;
float timeBuffer;

int preyCount;
int predatorCount;

int preyDataHeight;
int predatorDataHeight;

public void setup() {
  
  
  
  // user defined variables here
  cellSize = 10;
  preyChance = 5;
  predatorChance = 5;
  predatorMaxHealth = 25;
  preyMaxHealth = 50;
  
  percentDispData = 0.2f;
  dataPixelWidth = PApplet.parseInt(percentDispData * width);
  cellsPixelWidth = width - dataPixelWidth;
  
  cellsX = cellsPixelWidth/cellSize;
  cellsY = height/cellSize;
  
  predatorCells = new int[cellsX][cellsY];
  preyCells = new int[cellsX][cellsY];
  
  predatorCellsBuffer = new int[cellsX][cellsY];
  preyCellsBuffer = new int[cellsX][cellsY];
  
  predatorHealth = new int[cellsX][cellsY];
  preyHealth = new int[cellsX][cellsY];
  
  predatorHealthBuffer = new int[cellsX][cellsY];
  preyHealthBuffer = new int[cellsX][cellsY];

  maxSpeciesCount = cellsX * cellsY;
  dataCap = maxSpeciesCount / 4;

  timeDelay = 0;
  timeBuffer = 500;
 
  initializeCells();
}

public void initializeCells() {
  for(int x = 0; x < cellsX; x++) {
    for(int y = 0; y < cellsY; y++) {
      
      int randomNum = PApplet.parseInt(random(100));
      
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
  
public void draw(){
  if(millis() > timeBuffer) {
    calculateCells();
    drawCells();
    drawData();
    timeBuffer += timeDelay;
  }
}

public void calculateCells() {
  
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

public void moveCell(int x, int y) {
  newXY[0] = PApplet.parseInt(random(x-1, x+2));
  newXY[1] = PApplet.parseInt(random(y-1, y+2));
  
  if(!(newXY[0] >= 0 && newXY[0] < cellsX && newXY[1] >= 0 && newXY[1] < cellsY)) {
    newXY[0] = x;
    newXY[1] = y;
  }
}

public void drawCells() {
  for(int x = 0; x < cellsX; x++) {
    for(int y = 0; y < cellsY; y++) {
      if (predatorCells[x][y] == 1) {
        fill(255, 0, 0, predatorHealth[x][y] * 10 + 5);
        predatorCount++;
      }
      else if (preyCells[x][y] == 1) {
        fill(0, 255, 0, preyHealth[x][y] * 5 + 5);
        preyCount++;
      }
      else
        fill(0);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
}

public void drawData() {
  fill(0);
  rect(cellsPixelWidth, 0, dataPixelWidth, height);
  predatorDataHeight = -(int)map(predatorCount, 0.0f, dataCap, 0.0f, height);
  fill(255, 0, 0);
  rect(cellsPixelWidth, height, dataPixelWidth / 2, predatorDataHeight);
  preyDataHeight = -(int)map(preyCount, 0.0f, dataCap, 0.0f, height);
  fill(0, 255, 0);
  rect(cellsPixelWidth + dataPixelWidth / 2, height, dataPixelWidth / 2, preyDataHeight);
  predatorCount = 0;
  preyCount = 0;
}
  public void settings() {  size(displayWidth, displayHeight); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Predator_and_Prey" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
