//class that parses the text file for each round and creates and positions the required items
//all levels must contain a background shape (b) which must have at least 3 vertices as well as a start & target
class Background {

  FPoly b = new FPoly();
  FBox target = new FBox(96, 11);
  FBox start = new FBox(96, 11);
  FBox door = null;
  Bonus [] bonuses = {};
  PVector s, t, wind;
  PVector [] cloudPos = new PVector [3];
  PImage cloud, cloud2, black;
  ArrayList<FBody> obstacles = new ArrayList<FBody>();
  boolean boundless, landscape, controlDoor, doorOpen, noLeft, noRight;
  int bullets = 0;
  String text = "";

  void reset(String [] levels) {  //initialises a level
    wind  = new PVector(0, 0);
    for (int i = 0; i < cloudPos.length; i ++) {
      cloudPos[i] = new PVector(random(1920), random(540));
    }
    cloud = loadImage("cloud.png");
    cloud2 = loadImage("cloud2.png");
    for (int i = 0; i < levels.length; i ++) {//call parseRow on each row of the txt file
      String [] row = levels[i].split(" ");
      parseRow(row, i);
    }
    //this adds the mandatory FBodies
    b.setStatic(true);
    b.setNoStroke();
    b.setFill(0);
    //b.setFriction(1);
    b.setGrabbable(false);
    b.setName("background");
    world.add(b);
    world.add(start);
    world.add(target);
  }

  FBody parseRow(String[] row, int i) {
    for (int j = 0; j < row.length; j ++) { //remove empty strings and strings with only spaces in them
      if (row[j].equals("")) {
        for (int k = j; k < row.length-1; k ++) {
          row[k] = row[k+1];
        }
        j --;
        row = shorten(row);
      }
    }
    if (row.length > 0) {
      if (row.length == 1) {
        if (row[0].equals("boundless")) boundless = true;//allow rocket to go off the screen
        else if (row[0].equals("landscape")) {//create large world
          landscape = true;
          boundless = true;
        } else if (row[0].equals("noLeft")) {//disables the left arrow
          noLeft = true;
        } else if (row[0].equals("noRight")) {//disables the right arrow
          noRight = true;
        }
      } else if (row[0].equals("bullets")) {//gives the rocket bullets that can be fired with the spacebar
        bullets = int(row[1]);
      } else if (row[0].equals("text")) {//fills the text string which is displayed at the bottom of the screen
        int n = 1;
        while (n != -1) {
          try {
            text = text.concat(row[n] + " ");
            n ++;
          }
          catch(Exception e) {
            n = -1;
          }
        }
      } else {
        if (row.length >= 2) {
          //for all the following (except wind) the first two parameters are the coordinates of the item
          float x = float(trim(row[0]));
          float y = float(trim(row[1]));

          if (i == 0) {//first line of txt file is always start position
            s = new PVector(x*1920, y*1080);
            start.setPosition(x*1920, y*1080);
            start.setFill(200, 0, 0);
            start.setStatic(true);
            start.setFriction(2);
            start.setGrabbable(false);
            start.setName("start");
          } else if (i == 1) {//second line of txt file is always target position
            t = new PVector(x*1920, y*1080);
            target.setPosition(t.x, t.y);
            target.setFill(50, 200, 0);
            target.setStatic(true);
            target.setFriction(2);
            target.setGrabbable(false);
            target.setName("target");
          } else if (row.length == 2) {//adds a vertex to the background polygon
            b.vertex(x*1920, y*1080);
          } else if (row[2].equals("wind")) {//applies a wind to the enviroment (force given by (x, y))
            wind = new PVector(x, y);
          } else if (row[2].equals("time") || row[2].equals("health")
            || row[2].equals("fuel") || row[2].equals("all")) {//adds the bonus
            bonuses = (Bonus[]) append(bonuses, new Bonus(x*1920, y*1080, 24, row[2]));
          }
          //this adds both entrance and exit portals for a teleporter
          else if (row[2].equals("teleporter")) {
            bonuses = (Bonus[]) append(bonuses, new Bonus(x*1920, y*1080, 24, row[2],
              float(row[3])*1920, float(row[4])*1080));
          }
          //adds a black hole / repeller (fourth param is its radius)
          else if (row[2].equals("black") || row[2].equals("repeller")) {
            // black = loadImage("black hole.png");
            bonuses = (Bonus[]) append(bonuses, new Bonus(x*1920, y*1080,
              24, row[2], float(row[3])));
          }
          //adds a wall (stationary narrow obstacle) (fourth param is its radius e.g half its length
          //a negative radius makes it horizontal)
          else if (row[2].equals("wall")) {
            FBody f;
            float d  = 2 * float(row[3]);
            if (d > 0) f = new FBox(10, d);
            else f = new FBox(-d, 10);
            f.setGrabbable(false);
            f.setPosition(x*1920, y*1080);
            f.setStatic(true);
            f.setFill(0);
            f.setName("turnstile");
            world.add(f);
            obstacles.add(f);
            return f;
          }
          //adds a turnstile (fourth param is its radius) (fifth param is speed, setting to zero creates a static obstacle)
          else if (row[2].equals("turnstile")) {
            bonuses = (Bonus[]) append(bonuses, new Turnstile(x*1920, y*1080, float(row[3]), float(row[4])));
            return bonuses[bonuses.length-1].getBody();
          }
          //adds a slider (fourth param is its radius) (fifth param is speed) (sixth is start position (range from -1 to 1) or 2
          else if (row[2].equals("slider")) {
            bonuses = (Bonus[]) append(bonuses, new Turnstile(x*1920, y*1080,
              float(row[3]), float(row[4]), float(row[5])));
            return bonuses[bonuses.length-1].getBody();
          }
          //adds a circular non-static obstacle (fourth param is its radius) (fifth is optional for density)
          else if (row[2].equals("blob")) {
            FBody f = new FCircle(float(row[3]));
            f.setFill(100, 100, 0);
            try {
              f.setDensity(float(row[4]));
            }
            catch(Exception e) {
              f.setDensity(0.01);
            }
            f.setGrabbable(false);
            f.setPosition(x*1920, y*1080);
            world.add(f);
            obstacles.add(f);
            f.setName("box");
            return f;
          }
          //adds a rectangular non-static obstacle (fourth and fifth params are dimensions)
          //(sixth is optional for density)
          else if (row[2].equals("box")) {
            FBody f = new FBox(float(row[3]), float(row[4]));
            f.setFill(0, 100, 100);
            try {
              f.setDensity(float(row[5]));
            }
            catch(Exception e) {
              f.setDensity(0.01);
            }
            f.setGrabbable(false);
            f.setPosition(x*1920, y*1080);
            f.setName("blob");
            world.add(f);
            obstacles.add(f);
            return f;
          }
          //creates a chain between to objects (half-baked implementation here, do fix it :) )
          else if (row[2].equals("chain")) {
            int len;
            FBody[] steps = new FBody [100];
            float xTo, yTo;
            if (row.length < 11) {
              String [] a = {row[0], row[1], row[3], row[4]};
              String [] b = {row[5], row[6], row[7], row[8]};
              len = int(row[9]);
              steps[0] = parseRow(a, 2);
              steps[len-1] = parseRow(b, 2);
              yTo = float(row[6])*1080;
              xTo = float(row[5])*1920;
            } else {
              String [] a = {row[0], row[1], row[3], row[4], row[5]};
              String [] b = {row[6], row[7], row[8], row[9], row[10]};
              len = int(row[11]);
              steps[0] = parseRow(a, 2);
              steps[len-1] = parseRow(b, 2);
              yTo = float(row[7])*1080;
              xTo = float(row[6])*1920;
            }
            for (int j = 1; j < len-1; j ++) {
              steps[j] = new FCircle(5.0);
              steps[j].setFill(0);
              steps[j].setGrabbable(false);
              steps[j].setPosition(map(j, 0, len, x*1920, xTo), map(j, 0, len, yTo, y*1080));
              steps[j].setName("chain");
              world.add(steps[j]);
              obstacles.add(steps[j]);
            }
            for (int j = 1; j < len; j ++) {
              FDistanceJoint joint = new FDistanceJoint(steps[j-1], steps[j]);
              joint.setAnchor1(0, 0);
              joint.setAnchor2(0, 0);
              joint.setFill(128);
              if (i != 1 && i != len-1) joint.setLength(5);
              world.add(joint);
            }
          }
          //adds a button to the world which will open and close a door (nearly as bad as chain ...)
          //(fourth and fifth params are coordinates, sixth and seventh are dimensions)
          else if (row[2].equals("button")) {
            FBox f = new FBox(96, 10);
            f.setFill(255, 100, 0);
            f.setStatic(true);
            world.add(f);
            f.setFriction(2);
            f.setGrabbable(false);
            f.setName("button");
            f.setPosition(x*1920, y*1080);
            door = new FBox(float(row[5])*1920, float(row[6])*1080);
            door.setName("door");
            door.setFill(255, 255, 0, 100);
            door.setNoStroke();
            door.setGrabbable(false);
            door.setStatic(true);
            world.add(door);
            door.setPosition(float(row[3])*1920, float(row[4])*1080);
            controlDoor = true;
          } else if (row[2].equals("alien")) {
            bonuses = (Bonus[]) append(bonuses, new Alien(x*1920, y*1080,
              float(row[3]), float(row[4]), float(row[5])));
            return bonuses[bonuses.length-1].getBody();
          }
        }
      }
    }
    return null;
  }

  void controlDoor(boolean open) {
    if (open && !doorOpen) {
      doorOpen = true;
      world.remove(door);
    } else if (!open && doorOpen) {
      doorOpen = false;
      world.add(door);
    }
  }

  void controlBonuses(PVector rocketPos) {
    for (Bonus b : bonuses) {
      b.control(rocketPos);
    }
  }

  void control(PVector rocketPos) {//controls the clouds
    for (int i = 0; i < cloudPos.length; i ++) {
      image(cloud2, cloudPos[i].x, cloudPos[i].y, 100, 100);
      cloudPos[i].x += .5 + game.ship.wind.x/200;
      if (boundless) {
        if (cloudPos[i].x > 3940) cloudPos[i].x = -2020;
        else if (cloudPos[i].x < -2120) cloudPos[i].x = 3940;
      } else {
        if (cloudPos[i].x > 1920 + 100) cloudPos[i].x = -100;
        else if (cloudPos[i].x < -200) cloudPos[i].x = 1920;
      }
    }
  }
}
