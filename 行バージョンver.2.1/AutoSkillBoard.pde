import java.util.*;
import java.util.Collections;
PFont font;

int cols = 11;//列
int rows = 11;//行
int cellSize = 75;//行間距離
int nodeSum = 0;//ノードの数のカウント

//PVector[][] prev = new PVector[cols][rows];//座標
//boolean[][] nodechack = new boolean[cols][rows];//ノードの有無

//int[][] dist = new int[cols][rows];//探索距離

void setup() {
  background(255);
  fullScreen();

  // 日本語を含むフォントを指定
  font = createFont("MS Gothic", 16);
  textFont(font);

  view();
}

void draw() {
}

void set() {
  //setRowDistances();//探索距離の設定
  reset();
  NodeLimitSet();
  NodeDataSet();
  lineLimitSet();
  generateRandomConnections();
}

void reset() {
  nodeSum = 0;
  nodeData.clear();
  lineData.clear();
}

void view() {
  int maxRetry = 2000;
  int retry = 0;

  //do {
  //  set();
  //  retry++;
  //  if (retry > maxRetry) {
  //    println("警告: 入力0ノードが消せませんでした");
  //    break;
  //  }
  //} while (hasNodeWithZeroInput());  // ← 入力ゼロがあれば再生成

  set();
  fill(255);
  stroke(0);
  rect(50, 50, 100, 60);
  fill(0);
  text(retry, 100, 100);

  drawGrid();//グリッドの表示
  lineView();
  nodeView();
  NodeCheck();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    view();
  }

  if (key == 'd' || key == 'D') {
    redraw();
  }
}

boolean hasNodeWithZeroInput() {
  return false;
}
