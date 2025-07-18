import java.util.*;
import java.util.Collections;

PFont font;

float cellSize = 75;
int skillsum = 0;
int statussum = 0;
int startPosX;
int startPosY;

void setup() {
  background(255);
  fullScreen();

  // 日本語を含むフォントを指定
  font = createFont("MS Gothic", 16);
  textFont(font);

  startPosX = width/2;
  startPosY = height/2;


  view();
}

void draw() {
}

void set() {

  reset();

  DataSet();

  NodeDataSet();
}

void reset() {
  nodeData.clear();
}

void view() {
  background(255);
  set();

  NodeView();

  NodeCheck();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    reset();
    view();
  }

  if (key == 'd' || key == 'D') {
    redraw();
  }
}
