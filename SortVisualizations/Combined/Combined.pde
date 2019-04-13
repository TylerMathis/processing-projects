int[] arr, 
  arr2;

boolean sorting = false, 
  bubbleSorting = false, 
  selectionSorting = false, 
  insertionSorting = false;

int i, 
  j, 
  rectWidth, 
  winningIndex;

float t;

void setup()
{
  size(1000, 600);
  background(0);

  textSize(50);

  arr = new int[20];
  arr2 = new int[arr.length];

  rectWidth = width / arr.length;

  populateArr();
  scrambleArr(arr.length * 5);
  drawArr(false);
}

void draw()
{
  if (keyPressed)
  {
    // Populate each sort tag with the correct i and j start values
    /*
    
     b - bubble
     s - selection
     i - insertion
     r - randomize
     
     */
    if (!sorting) {
      if (key == 'b')
      {
        sorting = true;
        bubbleSorting = true;
        i = arr.length - 1;
        j = 0;
        t = millis();
      } else if (key == 's')
      {
        sorting = true;
        selectionSorting = true;
        i = arr.length - 1;
        j = 0;
        winningIndex = 0;
        t = millis();
      } else if (key == 'i')
      {
        sorting = true;
        insertionSorting = true;
        i = 0;
        j = 0;
        t = millis();
      } else if (key == 'r')
      {
        scrambleArr(arr.length * 5);
        drawArr(false);
      }
    }
  } else
  {
    /* BUBBLE START */
    if (bubbleSorting)
    {
      if (i >= 0)
      {        
        if (arr[j] > arr[j+1])
        {
          // swap array elements
          int temp = arr[j];
          arr[j] = arr[j+1];
          arr[j+1] = temp;

          drawArr(false);

          // redraw them swapped
          fill(255, 0, 0);
          rect(j*rectWidth, height, rectWidth, -arr[j]);
          rect((j+1)*rectWidth, height, rectWidth, -arr[j+1]);
          fill(255);
        }
        if (j < i)
        {
          j++;
        }
        if (j == i)
        {
          j = 0;
          i--;
        }
      } else
      {
        drawArr(false);
        fill(255, 0, 0);
        text("Time to bubbleSort: " + (millis() - t), 20, 50);
        fill(255);
        sorting = false;
        bubbleSorting = false;
      }
    }
    /* BUBBLE END */

    /* SELECTION START */
    if (selectionSorting)
    {
      if (i >= 0)
      {
        if (arr[j] > arr[winningIndex])
        {
          fill(255, 0, 0);
          rect(j*rectWidth, height, rectWidth, -arr[j]);
          fill(255);
          rect(winningIndex*rectWidth, height, rectWidth, -arr[winningIndex]);
          winningIndex = j;
        }
        if (j == i)
        {
          // swap array elements
          int temp = arr[j];
          arr[j] = arr[winningIndex];
          arr[winningIndex] = temp;

          drawArr(false);

          // reset indices
          winningIndex = 0;
          j = 0;
          i--;
        }
        if (j < i)
        {
          j++;
        }
      } else
      {
        fill(255, 0, 0);
        text("Time to selectionSort: " + (millis() - t), 20, 50);
        fill(255);
        sorting = false;
        selectionSorting = false;
      }
    }
    /* SELECTION END */

    /* INSERTION START */
    if (insertionSorting)
    {
      if (i < arr.length - 1)
      {
        drawArr(true);
        i++;
      } else
      {
        fill(255, 0, 0);
        text("Time to insertionSort: " + (millis() - t), 20, 50);
        fill(255);
        sorting = false;
        insertionSorting = false;
      }
    }
    /* INSERTION END */
  }
}

// fill array with 1 to arr.length - mapped to height
void populateArr()
{
  for (int i = 0; i < arr.length; i++)
  {
    arr[i] = (int)map(i, 0, arr.length, 0, height);
  }
}

// draw the array
void drawArr(boolean split)
{
  background(0);
  if (!split)
  {
    for (int i = 0; i < arr.length; i++)
      rect(rectWidth * i, height, rectWidth, -arr[i]);
  } else
  {
    for (int i = 0; i < arr.length; i++)
      rect(rectWidth * i, height / 2, rectWidth, -arr[i] / 2);
  }
}

// randomly scramble
void scrambleArr(int complexity)
{
  int r1, r2, temp;
  for (int i = 0; i < complexity; i++)
  {
    r1 = (int)random(0, arr.length);
    r2 = (int)random(0, arr.length);

    temp = arr[r1];
    arr[r1] = arr[r2];
    arr[r2] = temp;
  }
}
