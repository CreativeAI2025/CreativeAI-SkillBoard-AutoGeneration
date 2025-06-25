import java.util.*;
PFont font;

int cols = 11;//列
int rows = 11;//行
int cellSize = 75;//行間距離

PVector[][] prev = new PVector[cols][rows];//座標
boolean[][] nodechack = new boolean[cols][rows];//ノードの有無

int[][] dist = new int[cols][rows];//探索距離

void setup(){
  background(255);
  fullScreen();
  
  // 日本語を含むフォントを指定
  font = createFont("MS Gothic", 16);
  textFont(font);

  setAll();
  
  //NodeCheck();
  
  generateRandomConnections();
  
  //for (int[] c : connections) {
  //  println(c[0] + " → " + c[1]);
  //}
  
  nodeView();
  lineView();
}

void draw(){
  
}

void setAll(){
  setRowDistances();//探索距離の設定
  NodeLimitSet();
  NodeDataSet();  
}
