//class that displays and controls the bonuses (and some obstacles)

class Bonus {

  PVector pos;
  float r, value, value2;//the values have different meanings depending on the type
  String type;

  Bonus() {
  }

  Bonus(float x, float y, float r, String type) {
    pos = new PVector(x, y);
    this.r = r;
    this.type = type;
  }

  Bonus(float x, float y, float r, String type, float value) {
    pos = new PVector(x, y);
    this.r = r;
    this.type = type;
    this.value = value;
  }

  Bonus(float x, float y, float r, String type, float value, float value2) {
    pos = new PVector(x, y);
    this.r = r;
    this.type = type;
    this.value = value;
    this.value2 = value2;
  }

  void control(PVector rocketPos) {
    push();
    translate(pos.x, pos.y);
    stroke(0);
    strokeWeight(4);
    if (type.equals("black") || type.equals("repeller") ) {//draws succsessive transparent circles
      noStroke();
      if (value > 500) {
        for (float i = value; i > r; i -= 200) {
          if (type.equals("black")) fill(0, map(i, r, value, 0, 150));
          else fill(255, 0, 0, map(i, r, value, 0, 150));
          circle(0, 0, i*2);
        }
      } else {
        for (float i = value; i > r; i -= 100) {
          if (type.equals("black")) fill(0, map(i, r, value, 0, 100));
          else fill(255, 0, 0, map(i, r, value, 0, 100));
          circle(0, 0, i*2);
        }
      }
    } else if (type.equals("teleporter")) {
      fill(190, 190, 80);
      circle(0, 0, r*2);
      fill(150, 150, 0);
      circle(value-pos.x, value2-pos.y, r*2);
    } else {
      fill(150, 0, 255);
      circle(0, 0, r*2);
      if (type.equals("time")) { //clock symbol
        clock();
      } else if (type.equals("health")) { //draws a heart
        heart();
      } else if (type.equals("fuel")) {
        flame();
      } else if (type.equals("all")) {
        all();
      }
    }
    pop();
    //this is bad... applies a force to the rocket and then does the same for all the other obstacles
    if (type.equals("black") || type.equals("repeller")) {
      float mult = 500*sq(value);
      PVector toRocket = new PVector(rocketPos.x - pos.x, rocketPos.y - pos.y);
      float theta = PI+toRocket.heading();
      float mag = toRocket.mag();
      if (mag < r*2) {
        game.info.destroyed = true;
        game.info.health = -1;
        engine.playing = false;
        engine.gameOver = true;
      }
      mag = mult/sq(mag);
      if (type.equals("black")) game.ship.rocket.addForce(mag*cos(theta), mag*sin(theta));
      else game.ship.rocket.addForce(-mag*cos(theta), -mag*sin(theta));
      if (game.obstacles.size() > 0) {
        for (int i = 0; i < game.obstacles.size(); i ++) {
          FBody f = game.obstacles.get(i);
          PVector toF = new PVector(f.getX() - pos.x, f.getY() - pos.y);
          float thetaF = PI+toF.heading();
          float magF = toF.mag();
          magF = mult/sq(magF);
          if (type.equals("black")) f.addForce(magF*cos(thetaF), magF*sin(thetaF));
          else f.addForce(-magF*cos(thetaF), -magF*sin(thetaF));
        }
      }
    }
    //if center of rocket goes through one of these bonuses...
    if (pos.copy().dist(rocketPos) < r) {
      if (type.equals("all")) {
        game.info.time = 100;
        game.info.health = 100;
        game.info.hit = false;
        game.info.fuel = 100;
      }
      if (type.equals("time")) game.info.time = 100;
      else  if (type.equals("health")) {
        game.info.health = 100;
        game.info.hit = false;
      } else  if (type.equals("fuel")) game.info.fuel = 100;
      else  if (type.equals("teleporter")) game.ship.rocket.setPosition(value, value2);
    }
  }

  void heart() {
    noStroke();
    fill(255, 0, 0);
    circle(.3*r, -.3*r, .6*r);
    circle(-.3*r, -.3*r, .6*r);
    rotate(-PI/4);
    rectMode(CENTER);
    square(0, 0, .6*r);
  }

  void clock() {
    line(0, 0, .6*r, -.6*r);
    line(0, 0, -.4*r, -.4*r);
  }

  void flame() {
    image(game.flame, 0, 0, 35, 35);
  }

  void all() {
    translate(-10, 5);
    heart();
    rotate(PI/4);
    translate(20, 0);
    flame();
    stroke(0);
    strokeWeight(4);
    translate(-10, -5);
    clock();
  }

  FBody getBody() { //so that extended classes can use this method
    return null ;
  }
}
