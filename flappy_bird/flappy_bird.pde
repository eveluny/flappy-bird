// === Flappy Bird in Processing ===

PVector bird;
float birdVelocity = 0;
float gravity = 0.6;
float flapPower = -10;

float pipeX;
float pipeWidth = 60;
float pipeGap = 150;
float pipeSpeed = 3;
float topPipeHeight;

boolean gameOver = false;
int score = 0;

void setup() {
  size(600, 400);
  bird = new PVector(150, height/2);
  pipeX = width;
  topPipeHeight = random(50, height - pipeGap - 50);
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  background(135, 206, 250); // sky blue

  if (!gameOver) {
    // Update bird
    birdVelocity += gravity;
    bird.y += birdVelocity;

    // Bird
    fill(255, 255, 0);
    ellipse(bird.x, bird.y, 32, 32);

    // Pipes
    pipeX -= pipeSpeed;

    if (pipeX < -pipeWidth) {
      pipeX = width;
      topPipeHeight = random(50, height - pipeGap - 50);
      score++;
    }

    // Draw top pipe
    fill(34, 139, 34);
    rect(pipeX, 0, pipeWidth, topPipeHeight);

    // Draw bottom pipe
    rect(pipeX, topPipeHeight + pipeGap, pipeWidth, height);

    // Check collision
    if (bird.y > height || bird.y < 0 ||
        (bird.x + 16 > pipeX && bird.x - 16 < pipeX + pipeWidth &&
         (bird.y - 16 < topPipeHeight || bird.y + 16 > topPipeHeight + pipeGap))) {
      gameOver = true;
    }

    // Score
    fill(255);
    text("Score: " + score, width / 2, 30);
  } else {
    // Game over screen
    fill(0);
    text("Game Over!", width / 2, height / 2 - 30);
    text("Final Score: " + score, width / 2, height / 2 + 10);
    text("Press SPACE to Restart", width / 2, height / 2 + 50);
  }
}

void keyPressed() {
  if (!gameOver) {
    if (key == ' ' || key == 'w') {
      birdVelocity = flapPower;
    }
  } else {
    if (key == ' ') {
      resetGame();
    }
  }
}

void resetGame() {
  bird = new PVector(150, height/2);
  birdVelocity = 0;
  pipeX = width;
  topPipeHeight = random(50, height - pipeGap - 50);
  score = 0;
  gameOver = false;
}
