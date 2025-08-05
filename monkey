


// === Flappy Monkey with Bananas ===

PVector monkey;
float monkeyVelocity = 0;
float gravity = 0.6;
float flapPower = -10;
float monkeyAngle = 0;

float pipeX;
float pipeWidth = 60;
float pipeGap = 150;
float pipeSpeed = 3;
float topPipeHeight;
float pipeYOffset = 0;

int score = 0;
String gameState = "menu"; // "menu", "play", "gameOver"

// Images
PImage monkeyImage;
PImage bananaImage;

// Bananas
ArrayList<PVector> bananas = new ArrayList<PVector>();
int bananaSpacing = 200;
int bananaSpeed = 3;

void setup() {
  size(600, 400);
  textAlign(CENTER, CENTER);
  textSize(32);

  monkeyImage = loadImage("monkey.png");   // Place in data folder
  bananaImage = loadImage("banana.png");   // Place in data folder

  resetGame();

  // Spawn initial bananas
  for (int i = 0; i < 3; i++) {
    float bx = width + i * bananaSpacing;
    float by = random(50, height - 50);
    bananas.add(new PVector(bx, by));
  }
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
  text("🐒 Flappy Monkey", width / 2, height / 2 - 40);
  text("Press SPACE to Start", width / 2, height / 2 + 10);
  text("Press Q to Quit", width / 2, height / 2 + 50);
}

void runGame() {
  // === Monkey Physics ===
  monkeyVelocity += gravity;
  monkey.y += monkeyVelocity;

  // Animate tilt
  if (monkeyVelocity < 0) {
    monkeyAngle = radians(-20);
  } else {
    monkeyAngle = constrain(monkeyAngle + radians(2), radians(-20), radians(90));
  }

  // Draw monkey
  pushMatrix();
  translate(monkey.x, monkey.y);
  rotate(monkeyAngle);
  imageMode(CENTER);
  image(monkeyImage, 0, 0, monkeyImage.width * 0.2, monkeyImage.height * 0.2); // smaller head
  popMatrix();

  // === Bananas ===
  for (int i = bananas.size() - 1; i >= 0; i--) {
    PVector b = bananas.get(i);
    b.x -= bananaSpeed;

    // Draw banana
    image(bananaImage, b.x, b.y, bananaImage.width * 0.15, bananaImage.height * 0.15);

    // Recycle banana if off-screen
    if (b.x < -bananaImage.width) {
      b.x = width + random(100, 300);
      b.y = random(50, height - 50);
    }

    // Collision: Monkey collects banana
    if (dist(monkey.x, monkey.y, b.x, b.y) < 30) {
      score++;
      b.x = width + random(100, 300);
      b.y = random(50, height - 50);
    }
  }

  // === Pipes ===
  pipeX -= pipeSpeed;
  pipeYOffset = sin(frameCount * 0.03) * 20;

  if (pipeX < -pipeWidth) {
    pipeX = width;
    topPipeHeight = random(50, height - pipeGap - 50);
  }

  // Draw top pipe
  fill(139, 69, 19); // brown color
  rect(pipeX, pipeYOffset, pipeWidth, topPipeHeight);

  // Draw bottom pipe
  rect(pipeX, topPipeHeight + pipeGap + pipeYOffset, pipeWidth, height);

  // === Collision Check with Pipes ===
  if (monkey.y > height || monkey.y < 0 ||
      (monkey.x + 16 > pipeX && monkey.x - 16 < pipeX + pipeWidth &&
       (monkey.y - 16 < topPipeHeight + pipeYOffset ||
        monkey.y + 16 > topPipeHeight + pipeGap + pipeYOffset))) {
    gameState = "gameOver";
  }

  // === Score ===
  fill(255);
  text("🍌 Bananas: " + score, width / 2, 30);
}

void showGameOver() {
  fill(0);
  text("Game Over!", width / 2, height / 2 - 40);
  text("Bananas Collected: " + score, width / 2, height / 2);
  text("SPACE: Restart | R: Menu | Q: Quit", width / 2, height / 2 + 60);
}

void keyPressed() {
  if (gameState.equals("menu")) {
    if (key == ' ' || key == 'w') {
      gameState = "play";
    } else if (key == 'q' || key == 'Q') {
      exit();
    }
  } else if (gameState.equals("play")) {
    if (key == ' ' || key == 'w') {
      monkeyVelocity = flapPower;
      monkeyAngle = radians(-30); // Jump tilt
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
  }
}

void resetGame() {
  monkey = new PVector(150, height / 2);
  monkeyVelocity = 0;
  monkeyAngle = 0;
  pipeX = width;
  topPipeHeight = random(50, height - pipeGap - 50);
  score = 0;

  // Reset bananas
  bananas.clear();
  for (int i = 0; i < 3; i++) {
    float bx = width + i * bananaSpacing;
    float by = random(50, height - 50);
    bananas.add(new PVector(bx, by));
  }
}
