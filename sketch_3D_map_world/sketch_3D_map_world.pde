//control shift r = presentation mode
//neil turrok massey lectures

import java.awt.Robot;

//color pallette
color black = #000000;     // diamond
color  white = #FFFFFF;    // empty space
color dullBlue = #7092BE;  // crimson side

//textures
PImage diamond, dirt, grass_top, grass_side, furnace_end, furnace_side, furnace_front, crimson_top, crimson_bottom, crimson_side;

//Map variables
int gridSize;
PImage map;

Robot rbt;


//camera variables
float eyex, eyey, eyez;  //camera position
float focusx, focusy, focusz; //point at which camera faces
float upx, upy, upz; //tilt axis

//keyboard variables
boolean wkey, akey, dkey, skey;

//rotation variables
float leftRightAngle, upDownAngle;

void setup() {

  diamond = loadImage("diamond.png");
  dirt    = loadImage("dirt.png");
  grass_top = loadImage("grass_top.png");
  grass_side = loadImage("grass_side.png");
  furnace_end = loadImage("furnace_end.png");
  furnace_front = loadImage("furnace_front.png");
  furnace_side = loadImage("furnace_side.png");
  crimson_side = loadImage("crimson_side.png");
  crimson_top = loadImage("crimson_top.png");
  crimson_bottom = loadImage("crimson_bottom.png");
  textureMode(NORMAL);

  //noCursor();
  try {
    rbt = new Robot();
  } 
  catch(Exception e) {
    e.printStackTrace();
  }

  size(displayWidth, displayHeight, P3D);

  eyex = width/2;
  eyey = 9*height/10;
  eyez = height/2;


  upx = 0;
  upy = 1;
  upz = 0;

  //initialize map
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  background(0);

  //lights();
  pointLight(255, 255, 255, eyex, eyey, eyez);

  camera(eyex, eyey, eyez, focusx, focusy, focusz, upx, upy, upz);


  move();
  //drawAxis();
  drawFloor(-2000, 2000, height, gridSize);            //floor
  drawFloor(-2000, 2000, height-gridSize*4, gridSize); //ceiling
  drawMap();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == dullBlue) {
        texturedCube(x*gridSize - 2000, height - gridSize, y*gridSize - 2000, crimson_side, gridSize);
        texturedCube(x*gridSize - 2000, height - gridSize*2, y*gridSize - 2000, crimson_side, gridSize);
        texturedCube(x*gridSize - 2000, height - gridSize*3, y*gridSize - 2000, crimson_side, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize - 2000, height - gridSize, y*gridSize - 2000, diamond, gridSize);
        texturedCube(x*gridSize - 2000, height - gridSize*2, y*gridSize - 2000, diamond, gridSize);
        texturedCube(x*gridSize - 2000, height - gridSize*3, y*gridSize - 2000, diamond, gridSize);
      }
    }
  }
}

void move() {
  pushMatrix();
  translate(focusx, focusy, focusz);
  sphere(5);
  popMatrix();

  if (akey && canMoveLeft()) {
    eyex -=  cos(leftRightAngle + PI/2)*10;
    eyez -=  sin(leftRightAngle + PI/2)*10;
  }
  if (dkey && canMoveRight()) {
    eyex +=  cos(leftRightAngle + PI/2)*10;
    eyez +=  sin(leftRightAngle + PI/2)*10;
  }
  if (wkey && canMoveForward() ) {
    eyex +=  cos(leftRightAngle)*10; //same thing as: eyex = eyex + cos(leftRightAngle)*10;
    eyez +=  sin(leftRightAngle)*10;
  };
  if (skey && canMoveBackward()) {
    eyex -=  cos(leftRightAngle)*10; //same thing as: eyex = eyex + cos(leftRightAngle)*10;
    eyez -=  sin(leftRightAngle)*10;
  };

  focusx = eyex + cos(leftRightAngle)*300;
  focusy = eyey  +tan(upDownAngle)*300;
  focusz = eyez + sin(leftRightAngle)*300;

  if (mouseX > width-2) rbt.mouseMove(3, mouseY);
  if (mouseX < 2) rbt.mouseMove(width-3, mouseY);

  leftRightAngle = leftRightAngle + (mouseX - pmouseX)*0.01;
  upDownAngle = upDownAngle + (mouseY - pmouseY)*0.01;

  if (upDownAngle > PI/2.5) upDownAngle = PI/2.5;
  if (upDownAngle < -PI/2.5) upDownAngle = -PI/2.5;
}




boolean canMoveForward() {
  float fwdx, fwdy, fwdz;
  float leftx, lefty, leftz;
  float rightx, righty, rightz;
  int mapx, mapy;
  int mapx2, mapy2;

  fwdx = eyex + cos(leftRightAngle)*200;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle)*200;

  //leftx = eyex + cos(leftRightAngle + radians(20))*200;
  //lefty = eyey;
  //leftz = eyez + cos(leftRightAngle + radians(20))*200;

  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;

  //mapx2 = int(leftx+2000) / gridSize;
  //mapy2 = int(leftz+2000) / gridSize;


  if (map.get(mapx, mapy) == white) {
    return true;
  //} else { 
  //  if (map.get(mapx2, mapy2) == white) {
  //    return true;
    } else {

      return false;
    }
  }
//}


boolean canMoveLeft() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;

  fwdx = eyex + cos(leftRightAngle + radians(270))*200;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle + radians(270))*200;


  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;


  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveRight() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;

  fwdx = eyex + cos(leftRightAngle + radians(90))*200;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle + radians(90))*200;


  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;


  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveBackward() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;

  fwdx = eyex + cos(leftRightAngle + radians(180))*200;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle + radians(180))*200;


  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;


  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}


//void drawAxis() {
//}

void drawFloor(int start, int end, int level, int gap) {
  //line(x1, y1, z1, x2, y2, z2); 
  stroke(255);
  strokeWeight(1);

  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, diamond, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}
void keyPressed() {
  if (key == 'w' || key == 'W') wkey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 's' || key == 'S') skey = true;
  if (key == 'd' || key == 'D') dkey = true;
}


void keyReleased() {
  if (key == 'w' || key == 'W') wkey = false;
  if (key == 'a' || key == 'A') akey = false;
  if (key == 's' || key == 'S') skey = false;
  if (key == 'd' || key == 'D') dkey = false;
}
