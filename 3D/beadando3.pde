import java.util.Scanner;
import java.io.*;
float tomb[][]=new float[8][6];
int xmin=50, ymin=50, xmax=350, ymax=350;
int v1=1, v2=1, v3=-1, c=400, proj=0, cut=0;


void setup() {
  size(400, 400);
  background(255);
  File f=new File(sketchPath("in.txt"));
  try {
    Scanner sc=new Scanner(f);
    for (int i=0; i<tomb.length; i++) {
      for (int j=0; j<6; j++)
        tomb[i][j]=sc.nextInt();
      println(tomb[i][0]+" "+
        tomb[i][1]+" "+
        tomb[i][2]+" "+
        tomb[i][3]+" "+
        tomb[i][4]+" "+
        tomb[i][5]+" ");
    }
    sc.close();
  }
  catch (FileNotFoundException io) {
    println(io);
  }
}

void line2(int x1, int y1, int x2, int y2) {
    float db=abs(x2-x1)>abs(y2-y1)?abs(x2-x1):
      abs(y2-y1);
    float dx=(x2-x1)/db, dy=(y2-y1)/db, x=x1, y=y1;
    for (int i=0; i<=db; i++) {
      point(x, y);
      x+=dx;
      y+=dy;
    }
  }
  
  int sgn(int x) {
    if (x>0) return 1;
    if (x<0) return -1;
    return 0;
  }
  
  
  int ComputeOutCode(double x, double y)
  {
    int code = 0;  // initialised as being inside of clip window
    if (x < xmin)           // to the left of clip window
      code |= 1;
    else if (x > xmax)      // to the right of clip window
      code |= 2;
    if (y < ymin)           // below the clip window
      code |=4;
    else if (y > ymax)      // above the clip window
      code |= 8;
    return code;
  }
  
  void Cut(double x0, double y0, double x1, double y1) {

    int xmin=50, xmax=350, ymin=50, ymax=350;
    int code = 0;

    if (x0 < xmin)
      code |= 1;
    else if (x0 > xmax)
      code |= 2;
    if (y0 < ymin)
      code |= 4;
    else if (y0 > ymax)
      code |=8;
    int code1 = 0;
    if (x1 < xmin)
      code1 |= 1;
    else if (x1 > xmax)
      code1 |= 2;
    if (y1 < ymin)
      code1 |= 4;
    else if (y1 > ymax)
      code1 |=8;

    boolean accept = false;

    while (true) {
      if (0==(code | code1)) {
        accept = true;
        break;
      } else if (0!=(code & code1)) {
        break;
      } else {
        double x=0, y=0;
        int outcodeOut = code1 > code ? code1 : code;
        if (0!=(outcodeOut & 8)) {
          x = x0 + (x1 - x0) * (ymax - y0) / (y1 - y0);
          y = ymax;
        } else if (0!=(outcodeOut & 4)) {
          x = x0 + (x1 - x0) * (ymin - y0) / (y1 - y0);
          y = ymin;
        } else if (0!=(outcodeOut & 2)) {
          y = y0 + (y1 - y0) * (xmax - x0) / (x1 - x0);
          x = xmax;
        } else if (0!=(outcodeOut & 1)) {
          y = y0 + (y1 - y0) * (xmin - x0) / (x1 - x0);
          x = xmin;
        }

        if (outcodeOut == code) {
          x0 = x;
          y0 = y;
          code = 0;
          if (x0 < xmin)
            code |= 1;
          else if (x0 > xmax)
            code |= 2;
          if (y0 < ymin)
            code |= 4;
          else if (y0 > ymax)
            code |=8;
        } else {
          x1 = x;
          y1 = y;
          code1 = 0;
          if (x1 < xmin)
            code1 |= 1;
          else if (x1 > xmax)
            code1 |= 2;
          if (y1 < ymin)
            code1 |= 4;
          else if (y1 > ymax)
            code1 |=8;
        }
      }
    }
    if (accept)
      line2((int)x0, (int)y0, (int)x1, (int)y1);
  }


void draw() {
  background(255);
  for (int i=0; i<tomb.length; i++) {
    if ( proj == 0) {
      if ( cut==1) {
        Cut(
          (int)(tomb[i][0]-tomb[i][2]/v3*v1),
          (int)(tomb[i][1]-tomb[i][2]/v3*v2),
          (int)(tomb[i][3]-tomb[i][5]/v3*v1),
          (int)(tomb[i][4]-tomb[i][5]/v3*v2));
    } else {
      line2(
        (int)(tomb[i][0]-tomb[i][2]/v3*v1),
        (int)(tomb[i][1]-tomb[i][2]/v3*v2),
        (int)(tomb[i][3]-tomb[i][5]/v3*v1),
        (int)(tomb[i][4]-tomb[i][5]/v3*v2));
    } } else {
      if ( cut==0) {
        line2(
          (int)(tomb[i][0]*(1+tomb[i][2]/(c-tomb[i][2]))),
          (int)(tomb[i][1]*(1+tomb[i][2]/(c-tomb[i][2]))),
          (int)(tomb[i][3]*(1+tomb[i][5]/(c-tomb[i][5]))),
          (int)(tomb[i][4]*(1+tomb[i][5]/(c-tomb[i][5]))));
      } else {
        Cut(
          (int)(tomb[i][0]*(1+tomb[i][2]/(c-tomb[i][2]))),
          (int)(tomb[i][1]*(1+tomb[i][2]/(c-tomb[i][2]))),
          (int)(tomb[i][3]*(1+tomb[i][5]/(c-tomb[i][5]))),
          (int)(tomb[i][4]*(1+tomb[i][5]/(c-tomb[i][5]))));
      }
    }
  }
}

void keyPressed() {
    if (key == CODED) {
      // mozgatás
      if (keyCode == UP) {
        for (int i=0; i<tomb.length; i++)
        {
          tomb[i][1]--;
          tomb[i][4]--;
        }
      } else if (keyCode == DOWN) {
        for (int i=0; i<tomb.length; i++)
        {
          tomb[i][1]++;
          tomb[i][4]++;
        }
      } else if (keyCode == LEFT) {
        for (int i=0; i<tomb.length; i++)
        {
          tomb[i][0]--;
          tomb[i][3]--;
        }
      } else if (keyCode == RIGHT) {
        for (int i=0; i<tomb.length; i++)
        {
          tomb[i][0]++;
          tomb[i][3]++;
        }
      }
    } else {
      if (key =='r') {
        // forgatás
        float a=0.1;
        for (int i=0; i<tomb.length; i++)
        {
          float x=tomb[i][0];
          tomb[i][0]=tomb[i][0]*cos(a)-tomb[i][1]*sin(a);
          tomb[i][1]=x*sin(a)+tomb[i][1]*cos(a);
          x=tomb[i][3];
          tomb[i][3]=tomb[i][3]*cos(a)-tomb[i][4]*sin(a);
          tomb[i][4]=x*sin(a)+tomb[i][4]*cos(a);
        }
      } else if (key =='p') {
        // parallel és centrális projekció
        proj=++proj%2;
        //proj = (proj + 1) % 2;
      } else if (key =='c') {
        // vágás megjelenítése, eltűntetése
        cut=++cut%2;
      } else
        ;
    }
  }
