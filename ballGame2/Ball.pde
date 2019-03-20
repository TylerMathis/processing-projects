class Ball
{
  int size, velocityX, velocityY;
  color col;
    
  int posX, posY;
  
  Ball(int _size, color _col, int _velocityX, int _velocityY)
  {
    size = _size;
    velocityX = _velocityX;
    velocityY = _velocityY;
    
    col = _col;

    posX = 0;
    posY = 0;
  }
  
  void move()
  {
    posX += velocityX;
    posY += velocityY;
  }
  
  void disp()
  {
    fill(col);
    circle(posX, posY, size);
  }
}
