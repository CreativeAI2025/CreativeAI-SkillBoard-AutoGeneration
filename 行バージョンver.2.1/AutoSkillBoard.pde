import java.util.*;
import java.util.Collections;

PFont font;

int cols = 11;//列
int rows;//行
int cellSize = 75;//行間距離
int nodeSum = -1;//ノードの数のカウント

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

  DataSet();

  NodeDataSet();

  generateRandomConnections();
}

void reset() {
  rows = 0;
  nodeSum = 0;
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
  background(200);

  do {
    set();
    retry++;
    if (retry > maxRetry) {
      //println("警告: 入力0ノードが消せませんでした");
      break;
    }
  } while (hasNodeWithZeroInput());

  //set();

  TagSet();
  SkillDataSet();

  //drawGrid();//グリッドの表示
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
  ArrayList<Integer> endList = new ArrayList<>();
  for (int[] pair : connections) {
    //println(pair[0]+"→"+pair[1]);
    endList.add(pair[1]);
  }

  Collections.sort(endList);

  //for (Integer list: endList) {
  //  println(list);
  //}

  for (int i = 1; i < nodeSum; i++) {
    if (endList.contains(i)) {
      //println(i + " はリストに含まれています");
    } else {
      //println(i + " はリストに含まれていません");
      return true;
    }
  }

  return false;
}
