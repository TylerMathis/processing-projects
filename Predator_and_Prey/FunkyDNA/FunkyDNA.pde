float theta;

int delay;
int delayBuffer;

void setup() {
  background(0);
  size(1000, 850);
  theta = 0;
  
  delay = 1;
  delayBuffer = 200;
}

void draw() {
  if (millis() > delayBuffer) {
    
    background(0);
    fill(255);
    for (int i = 0; i < height / 5; i++) {
      float rectWidth = (width * sin(theta + i));
      fill(i*1, i*2, i*3);
      rect(width / 2 - rectWidth / 2, i * 5, rectWidth, 5);
    }
    theta += 0.02;
    delayBuffer += delay;
    
  }
}
