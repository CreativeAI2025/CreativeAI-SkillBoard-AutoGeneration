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

  LineDataSet();

  SkillDataSet();
  
  SkillOrStatusData();
}

void reset() {
  nodeData.clear();
  lineData.clear();
  tagData.clear();
  nodeSkillData.clear();
}
int maxRetry = 0;
int retry = 0;

void view() {
  maxRetry = 100;
  retry = 0;
  background(255);

  //set();
  
  do {
    set();
    retry++;
    if (retry > maxRetry) {
      text("失敗",100,100);
      println("失敗");
      break;
    }
  } while (getPanelSize() != 6);
  

  TagSet();

  lineView();
  NodeView();

  NodeCheck();
  println(getPanelSize());
  text("スキルパネルのサイズ"+getPanelSize(),100,50);
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
