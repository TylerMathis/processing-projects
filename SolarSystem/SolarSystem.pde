import queasycam.*;

ArrayList<Planet> planets = new ArrayList<Planet>();
int time = 0;

int state = 0;
String result = "";

float sScale = 1;

boolean answering = false;
boolean orbits = true;

QueasyCam cam;

void setup()
{
  noStroke();
  
  size(displayWidth, displayHeight, P3D);
  planets.add(new Planet(0.38709893,  0.3825,  0.2408467,  color(170)));
  planets.add(new Planet(0.72333199,  0.9488,  0.61519726, color(100)));
  planets.add(new Planet(1.00000011,  1,       1.0000174,  color(0, 119, 190)));
  planets.add(new Planet(1.52366231,  0.53260, 1.8808476,  color(80, 33, 0)));  
  planets.add(new Planet(5.20336301,  11.209,  11.862615,  color(205,133,63)));
  planets.add(new Planet(9.53707032,  9.449,   29.447498,  color(218, 165, 32), true));
  planets.add(new Planet(19.19126393, 4.007,   84.016846,  color(235, 206, 250)));
  planets.add(new Planet(30.06896348, 3.883,   164.79132,  color(0, 0, 255), true));
  
  cam = new QueasyCam(this);
  cam.speed = 100000 * Planet.scale;
  cam.sensitivity = 0.5;
  
  perspective(PI/3, (float)width/height, 1, 1000000000);
}

void draw()
{
  pollInput();
  updatePlanets();
  time++;
}

// case system for input
void pollInput()
{
  switch (state)
  {
    case 1:
      answering = true;
      break;
    case 2:
      state = 0;
      answering = false;
      changePScale(Integer.parseInt(result));
      result = "";
      break;
  }
}

// handle key inputsa
void keyPressed()
{
  // new scale
  if (key == ENTER || key == RETURN)
  {
    state++;
    print(state);
  }
  
  // enter new scale
  else {
    if (key == '1' || key == '2')
      result = result + key;
  }
  
  // show orbits
  if (key == 'o')
  {
    orbits = !orbits;
  }
}

// if we want to change scale
void changePScale(int nScale)
{
  for (Planet planet : planets)
  {
    planet.setPScale(nScale);
  }
}

void updatePlanets()
{
  background(0);
  
  // draw text box
  if (answering)
  {
    textSize(1000);
    fill(255);
    pushMatrix();
    rotateZ(-PI);
    rotateX(PI);
    text("Please enter planet scale factor (integer): \n" + result, 0, 0);
    popMatrix();
  }

  // draw sun
  fill(255, 255, 0);
  sphere(2 * 109 * Planet.ER * Planet.scale);
  
  // iterate through and draw planets
  for (Planet planet : planets)
  {
    planet.calcPos(time);
    planet.drawObject(orbits);
  }
}
