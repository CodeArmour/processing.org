import java.util.Scanner;
import java.io.*;


float[][] t=new float[8][4];
float[][] fl=new float[3][4];
int cX, cY;
float flagX, flagY;


PVector flagCenter() {
  flagX = 0;
  flagY = 0;
  for (int i = 0; i< fl.length; i++) {
    flagX += (fl[i][0])/3.;
    flagY += (fl[i][1])/3.;
  }
  return new PVector(flagX,flagY);
}


void calculateCenter() {
  cX = 0;
  cY = 0;
  for (int i = 0; i < t.length; i++) {
    cX += (t[i][0] + t[i][2]) / 2.0;
    cY += (t[i][1] + t[i][3]) / 2.0;
  }
  cX /= t.length;
  cY /= t.length;
}


void setup() {
  size(600, 600);
  background(255);
  File f=new File(sketchPath("in.txt"));
  try {
    Scanner sc=new Scanner(f);
    int a, b, c, d;
    for(int i=0;i<t.length;i++){
        for(int j=0;j<t[0].length;j++)
          t[i][j]=sc.nextInt();
    }
    sc.close();
    for (int i = 0; i<fl.length; i++) {
      for (int j = 0; j<fl[0].length; j++) {
        fl[i][j] = t[i][j];
      }
    }
  }
  catch (FileNotFoundException io) {
    println(io);
  }
  calculateCenter();
}


void draw(){
   background(255);
  for(int i=0;i<t.length;i++){       
            line_2((int)t[i][0],(int)t[i][1],(int)t[i][2],(int)t[i][3]);
          }
          PVector vect = flagCenter();
          fill_1(round(vect.x), round(vect.y));
          //point(320,126.67);
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      up();
    } else if (keyCode == DOWN) {
      down();
    } else if (keyCode == RIGHT) {
      right();
    } else if (keyCode == LEFT) {
      left();
    } 
  } else{
    if(key=='A'||key=='a'){
      zoomOutC();
    }else if(key=='S'||key=='s'){
      zoomInC();
    }else{
      if(keyCode == 'W'||key=='w'){
        rotateLinesCw(t, fl, cX, cY, 0.05);
      }else if(keyCode=='X'||key=='x'){
        rotateLinesCw(t, fl, cX, cY, -0.05);
      }
    }
  }
}


void fill_1(int x, int y) {
  int c=get(x, y);
  if (c==-1){
    point(x,y);
    fill_1(x+1,y);
    fill_1(x,y-1);
    fill_1(x-1,y);
    fill_1(x,y+1);
  }
}


void rotateLinesCw(float[][] lines1, float[][] lines2, float cx, float cy, float angle) {
  for (int i = 0; i < lines1.length; i++) {
    float old_x = lines1[i][0]; // x1
    float old_y = lines1[i][1]; // y1

    // Rotate the first endpoint (x1, y1)
    lines1[i][0] = (old_x - cx) * cos(angle) - (old_y - cy) * sin(angle) + cx;
    lines1[i][1] = (old_x - cx) * sin(angle) + (old_y - cy) * cos(angle) + cy;

    old_x = lines1[i][2]; // x2
    old_y = lines1[i][3]; // y2

    // Rotate the second endpoint (x2, y2)
    lines1[i][2] = (old_x - cx) * cos(angle) - (old_y - cy) * sin(angle) + cx;
    lines1[i][3] = (old_x - cx) * sin(angle) + (old_y - cy) * cos(angle) + cy;
  }
  
  for (int i = 0; i < lines2.length; i++) {
    float old_x = lines2[i][0]; // x1
    float old_y = lines2[i][1]; // y1

    // Rotate the first endpoint (x1, y1)
    lines2[i][0] = (old_x - cx) * cos(angle) - (old_y - cy) * sin(angle) + cx;
    lines2[i][1] = (old_x - cx) * sin(angle) + (old_y - cy) * cos(angle) + cy;

    old_x = lines2[i][2]; // x2
    old_y = lines2[i][3]; // y2

    // Rotate the second endpoint (x2, y2)
    lines2[i][2] = (old_x - cx) * cos(angle) - (old_y - cy) * sin(angle) + cx;
    lines2[i][3] = (old_x - cx) * sin(angle) + (old_y - cy) * cos(angle) + cy;
  }
}


void up() {
  for(int i = 0; i < t.length; i++) {
    t[i][1]-=10;
    t[i][3]-=10;
  }
  for(int i=0;i<fl.length;i++){
    fl[i][1]-=10;
    fl[i][3]-=10;
  }
}


void down() {
  for(int i = 0; i < t.length; i++) {
    t[i][1]+=10;
    t[i][3]+=10;
  }
  for(int i=0;i<fl.length;i++){
    fl[i][1]+=10;
    fl[i][3]+=10;
  }
}


void right() {
  for(int i = 0; i < t.length; i++) {
    t[i][0]+=10;
    t[i][2]+=10;
  }
  for(int i=0;i<fl.length;i++){
    fl[i][0]+=10;
    fl[i][2]+=10;
  }
}

void left() {
  for(int i = 0; i < t.length; i++) {
    t[i][0]-=10;
    t[i][2]-=10;
  }
  for(int i=0;i<fl.length;i++){
    fl[i][0]-=10;
    fl[i][2]-=10;
  }
}


void zoomOutC() {
  // Define the zoom factor
  float zoomFactor = 0.98;

  // Calculate the center point of the graph
  calculateCenter();

  // Apply zoom out to each element in the 2D array
  for (int i = 0; i < t.length; i++) {
    for (int j = 0; j < t[0].length; j++) {
      t[i][j] = cX + (t[i][j] - cX) * zoomFactor;
    }
  }
  for (int i = 0; i < fl.length; i++) {
    for (int j = 0; j < fl[0].length; j++) {
      fl[i][j] = cX + (fl[i][j] - cX) * zoomFactor;
    }
  }
}


void zoomInC() {
  // Define the zoom factor
  float zoomFactor = 1.02;

  // Calculate the center point of the graph
  calculateCenter();

  // Apply zoom in to each element in the 2D array
  for (int i = 0; i < t.length; i++) {
    for (int j = 0; j < t[0].length; j++) {
      t[i][j] = cX + (t[i][j] - cX) * zoomFactor;
    }
  }
  for (int i = 0; i < fl.length; i++) {
    for (int j = 0; j < fl[0].length; j++) {
      fl[i][j] = cX + (fl[i][j] - cX) * zoomFactor;
    }
  }
}

void line_2(int x1, int y1, int x2, int y2) {
  int i;
  float x = x1; // Initialize x and y to the starting point
  float y = y1;

  int dx = x2 - x1;
  int dy = y2 - y1;

  if (abs(dx) > abs(dy)) {
    i = abs(dx);
  } else {
    i = abs(dy);
  }

  float xIncrement = (float)dx / i;
  float yIncrement = (float)dy / i;

  for (int j = 0; j < i; j++) {
    point(x, y);
    x += xIncrement;
    y += yIncrement;
  }
}
