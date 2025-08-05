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

String gameState = "menu"; // "menu", "play", "gameOver", "tutorial"

PImage monkeyImage;
PImage bananaImage;

ArrayList<PVector> bananas = new ArrayList<PVector>();

void setup() {
  size(600, 400);
  textAlign(CENTER, CENTER);
  textSize(32);

  monkeyImage = loadImage("monkey.png");
  bananaImage = loadImage("banana.png");

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
  } else if (gameState.equals("tutorial")) {
    showTutorial();
  }
}

void showMenu() {
  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);

  imageMode(CENTER);
  image(monkeyImage, width / 2 - 120, height / 2 - 40, 40, 40);
  text("Flappy Monkey", width / 2 + 20, height / 2 - 40);

  textSize(24);
  text("Press SPACE to Start", width / 2, height / 2 + 10);
  text("Press T for Tutorial", width / 2, height / 2 + 40);
  text("Press Q to Quit", width / 2, height / 2 + 70);
}

void showTutorial() {
  background(255);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(22);
  text("How to Play:", width / 2, 50);

  textSize(18);
  text("Click or Press SPACE/W to Flap", width / 2, 120);
  text("Collect Bananas for Points", width / 2, 160);
  text("Avoid the Pipes", width / 2, 200);
  text("Hitting a Pipe or the Ground Ends the Game", width / 2, 240);

  textSize(16);
  text("Press M to return to the Menu", width / 2, height - 40);
}

void runGame() {
  birdVelocity += gravity;
  bird.y += birdVelocity;

  if (birdVelocity < 0) {
    birdAngle = radians(-20);
  } else {
    birdAngle = constrain(birdAngle + radians(2), radians(-20), radians(90));
  }

  pushMatrix();
  translate(bird.x, bird.y);
  rotate(birdAngle);
  imageMode(CENTER);
  image(monkeyImage, 0, 0, 60, 60);
  popMatrix();

  pipeX -= pipeSpeed;
  pipeYOffset = sin(frameCount * 0.03) * 20;

  if (pipeX < -pipeWidth) {
    pipeX = width;
    topPipeHeight = random(50, height - pipeGap - 50);
    score++;

    // Add banana
    float bananaY = random(topPipeHeight + 50, topPipeHeight + pipeGap - 50);
    bananas.add(new PVector(width, bananaY));
  }

  // Draw pipes
  fill(0, 200, 0); // green
  rect(pipeX, pipeYOffset, pipeWidth, topPipeHeight);
  rect(pipeX, topPipeHeight + pipeGap + pipeYOffset, pipeWidth, height);

  // Draw bananas
  for (int i = bananas.size() - 1; i >= 0; i--) {
    PVector b = bananas.get(i);
    b.x -= pipeSpeed;

    //image(bananaImage, b.x, b.y, 20, 20); // small banana
    image(bananaImage, b.x, b.y, 80, 80);

    if (dist(bird.x, bird.y, b.x, b.y) < 20) {
      score++;
      bananas.remove(i);
    }
  }

  if (bird.y > height || bird.y < 0 ||
    (bird.x + 16 > pipeX && bird.x - 16 < pipeX + pipeWidth &&
     (bird.y - 16 < topPipeHeight + pipeYOffset || bird.y + 16 > topPipeHeight + pipeGap + pipeYOffset))) {
    gameState = "gameOver";
  }

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
      exit();
    } else if (key == 't' || key == 'T') {
      gameState = "tutorial";
    }
  } else if (gameState.equals("play")) {
    if (key == ' ' || key == 'w') {
      birdVelocity = flapPower;
      birdAngle = radians(-30);
    }
  } else if (gameState.equals("gameOver")) {
    if (key == ' ') {
      resetGame();
      gameState = "play";
    } else if (key == 'r' || key == 'R') {
      gameState = "menu";
    } else if (key == 'q' || key == 'Q') {
      exit();
    }
  } else if (gameState.equals("tutorial")) {
    if (key == 'm' || key == 'M') {
      gameState = "menu";
    }
  }
}

void resetGame() {
  bird = new PVector(150, height / 2);
  birdVelocity = 0;
  birdAngle = 0;
  pipeX = width;
  topPipeHeight = random(50, height - pipeGap - 50);
  bananas.clear();
  score = 0;
}
