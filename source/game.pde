//class that controls the actual game

class Game {

  Background background;
  Info info = new Info();
  Ship ship;
  boolean up, left, right, door, knocked;
  PVector v = new PVector(0, 0);
  ArrayList<FBody> obstacles;
  PImage flame, blackHole;
  int bullets = 0;

  Game() {
    smooth();
    textSize(30);
    textAlign(CENTER, CENTER);
    imageMode(CENTER);
    flame = loadImage("flame.png");
    obstacles = new ArrayList<FBody>();
    String[] levels = loadStrings("level" + engine.level + ".txt");
    world = new FWorld(-1920, -1920, 3840, 3840);
    world.setGravity(0, 200);
    ship = new Ship();
    background = new Background();
    background.reset(levels);
    bullets = background.bullets;
    ship.rocket.setPosition(background.s.x, background.s.y - 48);
    ship.wind  = background.wind;
    for (int i = 0; i < background.obstacles.size(); i ++) {
      obstacles.add(background.obstacles.get(i));
    }
  }

  void control() {
    pushMatrix();
    if (background.landscape) {//position the screen
      float tx = 1920/2 - ship.rocket.getX();
      float ty = 1080/2 - ship.rocket.getY();
      tx = constrain(tx, -1920*.98, 1920*.98);
      ty = constrain(ty, -1080*.98, 1080*.98);
      translate(tx, ty);
    }
    background.control(ship.getPosition()); //clouds
    if(engine.level == 49){ //haha I'll let you decide if this is cheating
      fill(0);
      rect(0,.8*height, width, .8*height);
      rect(0,.2*height,.2*width, .6*height);
    }
    world.step();
    world.draw();
    ship.control();
    background.controlBonuses(ship.getPosition());
    if (ship.landed(background.t)) {
      engine.playing = false;
      engine.gameOver = true;
    }
    popMatrix();
    fill(255, 150, 255);
    text(background.text, 768, 972);
    if (background.controlDoor) background.controlDoor(door);
    info.control();
  }

  void fail() {
    game.info.health = -1;
    engine.playing = false;
    engine.gameOver = true;
  }

  void contactStarted(FContact c) {
    v = ship.getVelocity();
    if (c.contains("rocket", "door")) {
      info.destroyed = true;
      fail();
    }
    if (c.contains(ship.rocket) &&
      (!(c.contains(background.start) || c.contains(background.target)))) {
      info.hit = true;
      knocked = true;
    }
    String n1 = c.getBody1().getName();
    String n2 = c.getBody2().getName();
    if (c.contains("bullet")) {
      if (!n1.equals("background") && !n1.equals("door") && !n1.equals("target")
        && !n1.equals("turnstile") && !n1.equals("alien")) {
        world.remove(c.getBody1());
      }
      if (!n2.equals("background") && !n2.equals("door") && !n2.equals("target")
        && !n2.equals("turnstile") && !n2.equals("alien")) {
        world.remove(c.getBody2());
      }
      if (c.contains("rocket")) {
        info.shot = true;
        fail();
      }
    }
  }

  void contactPersisted(FContact c) {
    if (c.contains("button") && !c.contains("background")) {
      door = true;
    }
  }

  void contactEnded(FContact c) {
    if (v.x != 0 && v.y != 0 && knocked) {
      PVector z = v.copy().sub(ship.getVelocity());
      info.health -= z.mag()/5;
      knocked = false;
    }
    if (c.contains("button")) door = false;
  }

  void keyPressed() {
    if (keyCode == UP || key == 'w' || key == 'W') up = true;
    else if ((keyCode == LEFT || key == 'a' || key == 'A') && !background.noLeft) left = true;
    else if ((keyCode == RIGHT || key == 'd' || key == 'D') && !background.noRight) right = true;
    if (key == ' ' && bullets > 0) {//shoot!
      Bullet b = new Bullet(game.ship.rocket.getX(), game.ship.rocket.getY(),
        ship.rocket.getRotation() - PI/2, 5, 10000 + ship.getVelocity().copy().mag()*20);
      obstacles.add(b.getBody());
      bullets --;
    }
  }

  void keyReleased() {
    if (keyCode == UP || key == 'w' || key == 'W') up = false;
    else if (keyCode == LEFT || key == 'a' || key == 'A') left = false;
    else if (keyCode == RIGHT || key == 'd' || key == 'D') right = false;
  }
}
