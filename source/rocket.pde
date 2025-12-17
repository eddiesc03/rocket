//class that controls the spaceship, the object is called 'ship' but the FBody is called 'rocket'

class Ship {
  FPoly rocket;
  float s = 1920/45;
  PShape ship;
  ArrayList<Flame> flames = new ArrayList<Flame>();
  PVector wind;

  Ship() {
    rocket = new FPoly();
    v(0, -1);  //define the vertices of the rocket, by default it points up
    v(.2, -.7);
    v(.3, -.3);
    v(.3, .4);
    v(.43, .47);
    v(.5, .7);
    v(.5, 1);
    v(.2, .7);
    v(-.2, .7);
    v(-.5, 1);
    v(-.5, .7);
    v(-.43, .47);
    v(-.3, .4);
    v(-.3, -.3);
    v(-.2, -.7);
    rocket.setFill(220, 100, 0);
    rocket.setNoStroke();
    rocket.setGrabbable(false);
    rocket.setDensity(1);
    rocket.setBullet(true);
    rocket.setName("rocket");
    world.add(rocket);
    wind = new PVector(0, 0);
  }

  PVector getVelocity() {
    PVector out = new PVector(rocket.getVelocityX(), rocket.getVelocityY());
    return out;
  }

  PVector getPosition() {
    PVector out = new PVector(rocket.getX(), rocket.getY());
    return out;
  }

  void v(float x, float y) {//shorthand for rocket.vertex ... scaled
    rocket.vertex(x*s, y*s);
  }

  void display() {
    push();
    translate(rocket.getX(), rocket.getY());
    rotate(rocket.getRotation());
    fill(0);
    for (int i = 0; i < 4; i ++) {//rocket windows
      square(-.05*s, (i/3.0 - .5)* s, .1*s);
    }
    if (game.up) { //lots of flames
      for (int i = 0; i < 2; i ++) {
        flames.add(new Flame(rocket.getX() + s*random(.6,.8)*cos(rocket.getRotation()+PI/2),
          rocket.getY() + s*random(.6,.8)*sin(rocket.getRotation()+PI/2),
          random(2, 4) + random(2, 4) + random(2, 4) + random(2, 4) + random(2, 4),
          rocket.getRotation()+PI/2, random(100000)));
      }
    }
    if (game.left) { //flames coming out bottom-right
      for (int i = 0; i < 3; i ++) {
        flames.add(new Flame(rocket.getX() + s*random(.4,.6)*cos(rocket.getRotation()+PI/4),
          rocket.getY() + s*random(.4,.6)*sin(rocket.getRotation()+PI/4),
          random(3, 5), rocket.getRotation()+PI/4, random(100000)));
      }
    }
    if (game.right) {  //flames coming out bottom-left
      for (int i = 0; i < 3; i ++) {
        flames.add(new Flame(rocket.getX() + s*random(.4,.6)*cos(rocket.getRotation()+3*PI/4),
          rocket.getY() + s*random(.4,.6)*sin(rocket.getRotation()+3*PI/4),
          random(3, 5), rocket.getRotation()+3*PI/4, random(100000)));
      }
    }
    pop();
    for (int i = 0; i < flames.size(); i ++) { //remove flames that have disappeared
      flames.get(i).control();
      if (flames.get(i).size <= 0) flames.remove(i);
    }
  }

  void control() {//applies forces to the rocket
    float a = rocket.getRotation() + PI/2;
    rocket.addForce(wind.x, wind.y);
    if (((rocket.getX() < 0 || rocket.getY() < 0 || rocket.getX() > 1920 || rocket.getY() > 1080)
      && !game.background.boundless) ||
      (rocket.getX() < -1920*.98 || rocket.getY() < -1080*.98
      || rocket.getX() > 1920*1.98 || rocket.getY() > 1080*1.98)) {
      game.info.outOfBounds = true;
      game.fail();
    }
    if (keyPressed) {
      if (game.up) rocket.addForce(-3000*cos(a), -3000*sin(a));
      if (game.right) {
        rocket.addTorque(5);
        rocket.addForce(-500*cos(a), -500*sin(a));
      }
      if (game.left) {
        rocket.addTorque(-5);
        rocket.addForce(-500*cos(a), -500*sin(a));
      }
    }
    display();
  }

  boolean landed(PVector t) {//true if rocket has landed correctly on landing pad
    if (dist(t.x, t.y, rocket.getX(), rocket.getY()) < s+20 && same(rocket.getRotation(), 0)
      && abs(rocket.getVelocityX()) < .01 && abs(rocket.getVelocityY()) < .01) return true;
    return false;
  }

  boolean same(float a, float b) {//true if the angles are within PI/24 of each other
    float ab = abs(((a+TAU) % TAU) - ((b+TAU) % TAU));
    if (ab < PI/24 || ab > TAU - PI/24) return true;
    return false;
  }
}
