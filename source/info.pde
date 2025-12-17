//class that controls the info shown in the bottom-right corner of the screen when playing

class Info {

  float fuel;
  float health;
  float time;
  boolean hit, outOfBounds, destroyed, aborted, shot;

  Info() {
    fuel = 100;
    health = 100;
    time = 100;
    hit = false;
  }

  void control() {
    time -= .07;
    if (game.up) fuel -= .2;
    if (game.left) fuel -= .05;
    if (game.right) fuel -= .05;
    fill(128);
    text("Hit", 1920*.97, 1080*.91);
    if (!hit) {
      fill(255, 255, 0);
      displayStar(int(1920*.97), int(1080*.95), 20);
    }
    if (game.bullets > 0) {
      fill(150, 0, 0);
      text(game.bullets + " bullets", 1536, 1040);
    }
    fill(128);
    text("Level " + engine.level, 70, 1050);
    displaySlider(1536, 910, 288, fuel, "Fuel");
    displaySlider(1536, 960, 288, health, "Health");
    displaySlider(1536, 1010, 288, time, "Time");
    if (lost()) {
      game.fail();
    }
  }

  boolean lost() {
    if (fuel < 0 || health < 0 || time < 0) return true;
    return false;
  }

  int displayScore() {
    int n = 0;
    textSize(40);
    if (lost()) {
      fill(255, 0, 0);
      text("Level " + engine.level + " failed!", 960, 532);
      String cause = "?";
      if (destroyed) cause = "Your rocket was destroyed.";
      else if (aborted) cause = "You aborted this level.";
      else if (shot) cause = "Your rocket was shot.";
      else if (outOfBounds) cause = "Your rocket flew out of bounds.";
      else if (fuel < 0) cause = "Your rocket ran out of fuel.";
      else if (time < 0) cause = "Your rocket ran out of time.";
      else if (health < 0) cause = "Your rocket has become irrepairably damaged.";
      text(cause, 960, 640);
    } else {
      n = countScore();
      fill(50, 255, 50);
      text("Level " + engine.level + "  Completed!", 960, 532);
      fill(0);
      text("Score = " + n, 960, 586);
      fill(255, 255, 0);
      noStroke();
      for (int i = 0; i < 10; i ++) {
        if (i >= n) fill(120);
        displayStar(int(640 + i*71), 640, 32);
      }
    }
    return n;
  }

  int countScore() {
    return stars(fuel) + stars(health) + stars(time) + stars(hit);
  }

  int stars(float in) {
    if (in >= 40) return 3;
    if (in >= 25) return 2;
    if (in >= 10) return 1;
    return 0;
  }

  int stars(boolean b) {
    if (b) return 0;
    return 1;
  }

  void displaySlider(int x, int y, int w, float value, String name) {
    stroke(0);
    fill(128);
    rect(x, y, w, 10);
    text(name, x - 60, y - 15);
    noStroke();
    if (value > 0) {
      fill(50, 200, 0);
      rect(x, y, value*w/100, 10);
    }
    fill(220, 220, 0);
    if (value >= 10) {
      displayStar(x + w/10, y - 10, 20);
    }
    if (value >= 25) {
      displayStar(x + w/4, y - 10, 20);
    }
    if (value >= 40) {
      displayStar(x + w*4/10, y - 10, 20);
    }
  }
}
