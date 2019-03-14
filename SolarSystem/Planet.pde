class Planet
{
  // all necessary variables delcared
  float posX, posY, dis, rad, orbP;
  color col;
  final static float ER = 100;
  final static float AU = 23454.706481 * ER;
  final static float EP = 1000;
  
  final static float scale = 0.01;
  
  float pScale = 1;
  
  // constructor for planet
  Planet(float _dis, float _rad, float _orbP, color _col)
  { 
    dis = _dis * AU * scale;
    rad = _rad * ER * scale;
    orbP = _orbP * EP;
    
    col = _col;
  }
  
  // setter method for pScale
  void setPScale(int nScale)
  {
    pScale = nScale;
  }
  
  // calc new planet off of t
  void calcPos(float t)
  {
    // modulate t based on period
    t = t / orbP;
    
    // use sin and cos to draw a circle
    posX = (cos(t) * dis);
    posY = (sin(t) * dis);
  }
  
  // draw planet and orbit
  void drawPlanet(boolean orbits)
  {
    // draw planet
    fill(col);
    pushMatrix();
    translate(posX, posY, 0);
    sphere(2 * rad * pScale);
    popMatrix();
    
    if (orbits)
    {
    // draw orbit
    stroke(255);
    strokeWeight(0.5);
    noFill();
    ellipse(0, 0, 2 * dis, 2 * dis);
    noStroke();
    }
  }
}
