// === Flappy Bird in Processing ===

PVector bird;
float birdVelocity = 0;
float gravity = 0.6;
float flapPower = -10;
float birdAngle = 0;

float pipeX;
float pipeWidth = 60;
float pipeGap = 150;
float pipeSpeed = 3;
float topPipeHeight;
float pipeYOffset = 0;

int score = 0;

String gameState = "menu"; // "menu", "play", "gameOver"

void setup() {
  size(600, 400);
  textAlign(CENTER, CENTER);
  textSize(32);
  resetGame();
}

void draw() {
  background(135, 206, 250); // sky blue

  if (gameState.equals("menu")) {
    showMenu();
  } else if (gameState.equals("play")) {
    runGame();
  } else if (gameState.equals("gameOver")) {
    showGameOver();
  }
}

void showMenu() {
  fill(0);
  text("🐤 Flappy Bird", width / 2, height / 2 - 40);
  text("Press SPACE to Start", width / 2, height / 2 + 10);
  text("Press Q to Quit", width / 2, height / 2 + 50);
}

void runGame() {
  // === Bird ===
  birdVelocity += gravity;
  bird.y += birdVelocity;

  // Animate tilt
  if (birdVelocity < 0) {
    birdAngle = radians(-20);
  } else {
    birdAngle = constrain(birdAngle + radians(2), radians(-20), radians(90));
  }

  // Draw bird with rotation
  pushMatrix();
  translate(bird.x, bird.y);
  rotate(birdAngle);
  fill(255, 255, 0);
  ellipse(0, 0, 32, 32);
  popMatrix();

  // === Pipes ===
  pipeX -= pipeSpeed;

  // Wobble animation (sine wave offset)
  pipeYOffset = sin(frameCount * 0.03) * 20;

  if (pipeX < -pipeWidth) {
    pipeX = width;
    topPipeHeight = random(50, height - pipeGap - 50);
    score++;
  }

  // Draw top pipe
  fill(34, 139, 34);
  rect(pipeX, pipeYOffset, pipeWidth, topPipeHeight);

  // Draw bottom pipe
  rect(pipeX, topPipeHeight + pipeGap + pipeYOffset, pipeWidth, height);

  // === Collision Check ===
  if (bird.y > height || bird.y < 0 ||
      (bird.x + 16 > pipeX && bird.x - 16 < pipeX + pipeWidth &&
       (bird.y - 16 < topPipeHeight + pipeYOffset || bird.y + 16 > topPipeHeight + pipeGap + pipeYOffset))) {
    gameState = "gameOver";
  }

  // === Score ===
  fill(255);
  text("Score: " + score, width / 2, 30);
}

void showGameOver() {
  fill(0);
  text("Game Over!", width / 2, height / 2 - 40);
  text("Final Score: " + score, width / 2, height / 2);
  text("SPACE: Restart | R: Main Menu | Q: Quit", width / 2, height / 2 + 60);
}

void keyPressed() {
  if (gameState.equals("menu")) {
    if (key == ' ' || key == 'w') {
      gameState = "play";
    } else if (key == 'q' || key == 'Q') {
      exit(); // Quit the game
    }
  } else if (gameState.equals("play")) {
    if (key == ' ' || key == 'w') {
      birdVelocity = flapPower;
      birdAngle = radians(-30); // Jump tilt
    }
  } else if (gameState.equals("gameOver")) {
    if (key == ' ') {
      resetGame();
      gameState = "play";
    } else if (key == 'r' || key == 'R') {
      gameState = "menu";
    } else if (key == 'q' || key == 'Q') {
      exit(); // Quit the game
    }
  }
}

void resetGame() {
  bird = new PVector(150, height / 2);
  birdVelocity = 0;
  birdAngle = 0;
  pipeX = width;
  topPipeHeight = random(50, height - pipeGap - 50);
  score = 0;
}
