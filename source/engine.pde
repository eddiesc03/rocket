//class that controls all the menues and stores stats.

class Engine {

  boolean playing, gameOver, displayScoresheet, displayLevels, displayInfo, pause;
  int level = 1;
  int maxLevel = 50;
  String filePath = "C:rocket_scoresheet.txt";
  PImage rocket_pic = loadImage("rocket_pic.png");
  Button [] levels = {};
  Button playGame, nextLevel, info, scoresheet;

  Engine() {//create buttons
    float bw = 200;
    float bh = 100;
    playGame = new Button(320, 900, bw, bh, "Play Game", color(150, 255, 0));
    nextLevel = new Button(640, 900, bw, bh, "Next Level", color(0, 255, 0));
    info = new Button(960, 900, bw, bh, "Info", color(100, 255, 255));
    scoresheet = new Button(1280, 900, bw, bh, "Scoresheet", color(150, 0, 255));
    for (int i = 0; i < 50; i ++) {
      levels = (Button[]) append(levels, new Button(380 + (i%5)*320,
        80 + 77*floor(i/5), bh*3, 65, nf(i+1), color(50, 150, 50)));
    }
    myFont = createFont("Comic Sans MS", 70);
    textFont(myFont);
  }

  void control() {
    if (!pause) {
      background(80, 120, 200);
      if (displayScoresheet) {
        scoresheet.display();
        displayScoresheet();
      } else if (displayInfo) {
        info.display();
        displayInfo();
      } else {
        if (playing) {
          game.control();
        } else {
          textSize(500);
          fill(220, 100, 0, 150);
          text("Rocket !", 1920/2, 400);
          playGame.display();
          if (level < maxLevel) nextLevel.display();
          info.display();
          scoresheet.display();
          if (gameOver) resetScores();
          cursor();
          gameOver = false;
          try {
            game.info.displayScore();
          }
          catch (Exception e) {
          }
        }
      }
    }
  }

  void displayInfo() {
    textSize(30);
    imageMode(CORNER);
    text("Welcome to rocket!\nCan you land your rocket upright on the green destination pad each level? Better still, can you get 10 stars for each level?\n"
      + "Each of the 50 levels poses new challenges for your Rocket to navigate.\n "
      + "Be careful not to fly out of bounds, be shot by aliens, fly into any closed beige doors, or to fall into any black holes along the way.\n"
      + "Beige doors are opened while an object is on an orange pad.\n"
      + "In addition your rocket has limited time, fuel, and damage resistance, however these can be reset by flying through their respective purple power-ups. "
      + "Flying through the health power-up will also reset the hit star.\n"
      + "Controls and Shortcuts: use the arrow keys or AWD to control the spaceship" 
      + "(pressing A, D or side arrow keys will result in the rocket being propelled forward as well as rotated), press p to pause/unpause the game, m to go to menu, "
      + "shift to play next level, space to fire bullets (in some of the later levels), and r to restart the level.\n"
      + "\n"
      + "Good luck, hope you enjoy the game :)"
      , 0, 70, 1920, 1000);
    image(rocket_pic, 1250, 700, 570, 509);
  }

  void displayScoresheet() {
    for (Button b : levels) b.display();
    try {
      String [] scores = loadStrings(filePath);
      textSize(25);
      text("Click on any of the green buttons to play any level.", 400,900);
      for (int i = 1; i < scores.length; i ++) {
        fill(0);
        text("level " + i + ": " + scores[i] + "/10", ((i-1)%5)*320 + 330, (1+floor((i-1)/5.0))*77);
        fill(255, 255, 0);
        noStroke();
        for (int j = 0; j < 10; j ++) {
          if (j >= int(scores[i])) fill(120);
          displayStar((((i-1)%5) + 1)*320 + int(j*25 - 50), (1+floor((i-1)/5.0))*77 + 20, 15);
        }
      }
    }
    catch(Exception e) {//file problem
      println(e);
    }
  }

  void resetScores() {
    int n = 0;
    try {
      n = game.info.displayScore();// score from last level played
    }
    catch(Exception e) {
    }
    try {
      String [] scores = loadStrings(filePath);
      while (scores.length <= level) {
        scores = append(scores, "0");
      }
      if (int(scores[level]) < n) {//if last score was better than your best score for that level, update the score
        scores[level] = str(n);
        saveStrings(filePath, scores);
      }
    }
    catch(Exception e) {//if no file was found, create a new one and populate with zeroes until it reaches the level you just played
      String [] scores = new String [maxLevel + 1];
      scores[0] = "";
      for (int i = 0; i <= maxLevel; i ++) {
        scores[i] = "0";
      }
      if (int(scores[level]) < n) {//if last score was better than your best score for that level, update the score
        scores[level] = str(n);
        saveStrings(filePath, scores);
      }
      println(e);
    }
  }

  void startGame() {
    playing =  true;
    game = new Game();
    playGame.s = "Retry Level";
    gameOver = false;
    noCursor();
  }

  void mousePressed() {
    if (!playing) {
      if (displayScoresheet) {
        for (Button b : levels) {
          if (b.pressed()) { //try to run the selected level
            level = int(b.s);
            try {
              startGame();
              displayScoresheet = false;
              scoresheet.s = "Scoresheet";
            }
            catch(Exception e) {
              println(e);
              playing = false;
              level = 1;
            }
          }
        }
      }

      if (scoresheet.pressed()) { //toggle visability of scoresheet
        if (displayScoresheet) scoresheet.s = "Scoresheet";
        else  scoresheet.s = "Back";
        displayScoresheet = !displayScoresheet;
      }
      if (info.pressed()) { //toggle visability of info
        if (displayInfo) info.s = "Info";
        else  info.s = "Back";
        displayInfo = !displayInfo;
      }
      if (!displayScoresheet && !displayLevels && playGame.pressed()) startGame(); //run same level as before or ...
      // ... level 1 if no level has yet been played
      if (!displayScoresheet && !displayLevels && playing == false && nextLevel.pressed() && level < maxLevel) {
        //run next level after the one that was last played or level 2 if no level has yet been played
        nextLevel();
      }
    }
  }

  void keyPressed() { //various shortcuts
    if (playing) game.keyPressed();
    else if (keyCode == ENTER) startGame();
    else if (keyCode == SHIFT) nextLevel();
    if (key == 'm' || key == 'M') {//go to menu
      pause = false;
      gameOver = false;
      displayScoresheet = false;
      displayLevels = false;
      displayInfo = false;
      scoresheet.s = "Scoresheet";
      info.s = "Info";
      if (playing) {
        playing = false;
        game.info.aborted = true;
        game.info.health = -1;
      }
    } else if (key == 'r' || key == 'R') { //restart level
      pause = false;
      startGame();
    } else if (playing && !gameOver && (key == 'p' || key == 'P')) { //pause game
      pause = ! pause;
    }
  }

  void keyReleased() {
    if (playing) game.keyReleased();
  }

  void nextLevel() { //trys to run a new level if there is one and if the new level parses correctly
    level ++;
    try {
      startGame();
    }
    catch(Exception e) {//this should not run unless nextlevel is clicked after level 50 or if files are messed with
      level --;
      try {
        startGame();
      }
      catch(Exception e2) {//even less likely to run
        println(e2);
      }
    }
  }
}
