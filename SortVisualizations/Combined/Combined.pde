int[] arr;
boolean sorting = false, bubbleSorting = false;
int i, j, rectWidth;

void setup()
{
  size(1000, 600);
  background(0);

  arr = new int[100];

  rectWidth = width / arr.length;

  populateArr();
  scrambleArr(arr.length * 5);
  drawArr();
}

void draw()
{
  if (keyPressed)
  {
    // Populate each sort tag with the correct i and j start values
    if (key == 'b' && !sorting)
    {
      sorting = true;
      bubbleSorting = true;
      i = arr.length - 1;
      j = 0;
    }
    else if (key == 's' && !sorting)
    {
    }
    else if (key == 'r' && !sorting)
    {
      scrambleArr(arr.length * 5);
      drawArr();
    }
  }
  if (sorting)
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

          // fill the swapped pieces with black
          fill(0);
          rect(j*rectWidth, 0, 2*rectWidth, height);
          
          // redraw them swapped
          fill(255);
          rect(j*rectWidth, height, rectWidth, -arr[j]);
          rect((j+1)*rectWidth, height, rectWidth, -arr[j+1]);
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
        sorting = false;
        bubbleSorting = false;
      }
    }
    /* BUBBLE END */
    
  }
}

// fill array with 1 to arr.length
void populateArr()
{
  for (int i = 0; i < arr.length; i++)
  {
    arr[i] = (int)map(i, 0, arr.length, 0, height);
  }
}

// draw the array
void drawArr()
{
  background(0);
  for (int i = 0; i < arr.length; i++)
  {
    rect(rectWidth * i, height, rectWidth, -arr[i]);
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
