import processing.vr.*;

PMatrix3D m;
Box current;
ArrayList<Box> boxes;
int t, score, period, starttime, replay, time, hue;
float y;
PFont font;
String state;

void setup() {
  fullScreen(STEREO);
  background(0);
  colorMode(HSB,100);
  
  m = new PMatrix3D();
  boxes = new ArrayList<Box>();
  t = 0;
  y = 0;
  score = 0;
  period = 3000;
  font = createFont("Monospaced",20,true);
  cameraUp(); 
  state = "start";
  starttime = 20;
  replay = 10;
  hue = 0;
}

void draw() {
  background(0);
  //lights();
  
  if (state.equals("start")){
    startScreen();
  }
  
  if (state.equals("game")){
    showBoxesAndScore();
    scoreAndRemove();
    faster();
  }
  
  if (state.equals("dead"))
    deadScreen();
    
  if (state.equals("restart"))
    restart();
}

void startScreen() {
  if (starttime == 0){
    starttime = 10;
    state = "game";
  }
  if (millis() >= time + 1000){
    starttime --;
    time = millis();
  }
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(100, 0, 100);
  text("Welcome!", 0, 30, 0);
  text("Look up/down to", 0, 0, 0);
  text("avoid the platforms", 0, -30, 0);
  text("Start in " + starttime, 0, -60, 0);
}

void showBoxesAndScore() {
  //sets box as above or below x-axis
  if (int(random(2)) == 0)
    y = 720 / 4;
  else 
    y = -720 / 4;
  
  //adds box every period, adjusts color
  if (millis() > t + period) {
    boxes.add(new Box(0, y, -9000, score, hue));
    if (hue + 5 <= 100)
      hue += 5;
    else
      hue = 0;
    t = millis(); 
  } 
  
  //displays boxes
  if (boxes.size() > 0) {
    for (Box b : boxes)
      b.display();
  } 
  
  //displays score
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(100, 0, 100);
  text(score, 0, 0, 0);
}

void scoreAndRemove() {
  //gets current box
  if (current == null && boxes.size() > 0) {
    current = boxes.get(0);
  }
  else if (current != null && current.getCounted() == true) {
    for (int i = 0; i < boxes.size(); i ++) {
      if (boxes.get(i).getZ() < getCameraZ() && boxes.get(i).getCounted() == false) {
        current = boxes.get(i);
        break;
      }
    }
  }
  
  //successful ducking/jumping and score
  getEyeMatrix(m);
  if (current != null && current.getCounted() == false 
            && current.getZ() >= getCameraZ() && 
            (current.getY() > 0 && m.m21 < -.2 || current.getY() < 0 && m.m21 > .2)) {
    score ++;
    current.counted();
  }
  //dead
  else if (current != null && current.getCounted() == false 
            && current.getZ() >= getCameraZ() && 
            (current.getY() > 0 && m.m21 > -.2 || current.getY() < 0 && m.m21 < .2)) {
    time = millis();
    state = "dead";
  }
  
  //removes boxes
  for (int i = 0; i < boxes.size(); i ++)
    if (boxes.get(i).getZ() > 4000)
      boxes.remove(i);
}

void faster() {
  //inceases period as score increases
  if (score > 35)
    period = 600;
  else if (score > 30)
    period = 800;
  else if (score > 25)
    period = 1000;
  else if (score > 20)
    period = 1250;
  else if (score > 15)
    period = 1500;
  else if (score > 10)
    period = 2000;
  else if (score > 5)
    period = 2500;
  else
    period = 3000;
}

void deadScreen() {
  //countdown
  if (replay == 0)
    state = "restart";
  if (millis() >= time + 1000) {
    replay --;
    time = millis();
  }
  
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(100, 0, 100);
  text("You Died!", 0, 30, 0);
  text(score, 0, 0, 0);
  text("Restart in " + replay, 0, -30, 0);
}

void restart() {
  boxes = new ArrayList<Box>();
  current = null;
  t = 0;
  score = 0;
  period = 3000;
  replay = 10;
  hue = 0;
  state = "start";
}

float getCameraZ() {
    PMatrix3D eyeMatrix = new PMatrix3D();
    getEyeMatrix(eyeMatrix);
    return eyeMatrix.m23;
}
