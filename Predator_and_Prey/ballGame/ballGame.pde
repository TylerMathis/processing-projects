float speedX;
float speedY;

float ballWidth;
float ballHeight;

float ballX;
float ballY;

float leftEdge;
float rightEdge;
float topEdge;
float bottomEdge;

void setup() {
  background(0);
  size(500, 500);
  
  ballWidth = 100;
  ballHeight = 100;
  
  spawnBall();
}

void draw() {
  background(0);
  calcForce();
  moveBall();
}

void spawnBall() {
  ballX = width / 2;
  ballY = height / 2;
  
  speedX = random(-3, 3);
  speedY = random(-3, 3);
  
  ellipse(ballX, ballY, ballWidth, ballHeight);
}

void calcForce() {
  if (mouseX > leftEdge && mouseX < rightEdge && mouseY > topEdge && mouseY < bottomEdge) {
    print("on ball");
    
  if (mouseX < ballX) {
    speedX += 0.2;
  } else {
    speedX -= 0.2;
    }
  
  if (mouseY < ballY) {
    speedY += 0.2;
  } else {
    speedY -= 0.2;
    }
  }
}

void moveBall() {
  
  ballX += speedX;
  ballY += speedY;
  
  leftEdge = ballX - ballWidth / 2;
  rightEdge = ballX + ballWidth / 2;
  topEdge = ballY - ballHeight / 2;
  bottomEdge = ballY + ballHeight / 2;
  
  if (leftEdge < 0) {
    if (speedX < 0) {
      speedX = -speedX;
    }
  } else if (rightEdge > width) {
    if (speedX > 0) {
      speedX = -speedX;
    }
  }
  if (topEdge < 0) {
    if (speedY < 0) {
      speedY = -speedY;
    }
  } else if (bottomEdge > height) {
    if (speedY > 0) {
      speedY = -speedY;
    }
  }
  
  ellipse(ballX, ballY, ballWidth, ballHeight);
}
