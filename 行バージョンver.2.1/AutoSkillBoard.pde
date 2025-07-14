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
  
  DataSet();
  
  NodeDataSet();

  generateRandomConnections();
}

void reset() {
  nodeSum = 0;
  nodeData.clear();
  lineData.clear();
  tagData.clear();
}

void view() {
  int maxRetry = 100;
  int retry = 0;

  do {
    set();
    retry++;
    if (retry > maxRetry) {
      //println("警告: 入力0ノードが消せませんでした");
      break;
    }
  } while (hasNodeWithZeroInput());

  //set();
  fill(255);
  stroke(0);
  rect(50, 50, 300, 60);
  fill(0);
  text(retry, 100, 100);


  TagSet();
  SkillDataSet();
  
  text("スキル:" + skillCount + "ステータス:" + statusCount,150,100);
  
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
