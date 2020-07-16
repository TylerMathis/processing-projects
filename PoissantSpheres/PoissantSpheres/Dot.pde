class Dot {
  
  float x, y, size;
  float vx, vy;
  int time;
  
  boolean special;
  
  public Dot(int x, int y, float vx, float vy, int size, boolean special)
  {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = size;
    
    this.special = special;
  }
  
  public void drawDot() {
    if (special)
    {
      fill(255, 0 , 0);
      ellipse(this.x, this.y, this.size, this.size);
      fill(255);
    }
    else
      ellipse(this.x, this.y, this.size, this.size);
  }
  
  public void move() {
    this.x += vx;
    this.y += vy;
  }
  
  public void changeV(float newX, float newY) {
    this.vx = newX;
    this.vy = newY;
  }
}
