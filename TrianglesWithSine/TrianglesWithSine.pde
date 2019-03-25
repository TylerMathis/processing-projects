float theta;

int delay;
int delayBuffer;

void setup() {
  background(0);
  size(500, 500);
  theta = 0;
  
  delay = 1;
  delayBuffer = 200;
}

void draw() {
  if (millis() > delayBuffer) {
    
    background(0);
    fill(255);
    for (int i = 0; i < height / 5; i++) {
      float rectWidth = (width * sin(theta)) - sq(i);
      rect(width / 2 - rectWidth / 2, i * 5, rectWidth, 5);
    }
    theta += 0.01;
    delayBuffer += delay;
    
  }
}
