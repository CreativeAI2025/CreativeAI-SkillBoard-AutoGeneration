//import java.util.*;

//int cols = 11;
//int rows = 11;
//int cellSize = 50;

//PVector[][] prev = new PVector[cols][rows];
//boolean[][] hasParent = new boolean[cols][rows];
//boolean[][] nodechack = new boolean[cols][rows];
//boolean[][] visited = new boolean[cols][rows];

//int[][] dist = new int[cols][rows];
//int maxDist = 0;

//HashMap<Integer, Integer> nodeLimitPerDist = new HashMap<Integer, Integer>();
//HashMap<Integer, Integer> branchLimitPerDist = new HashMap<Integer, Integer>();
//HashMap<String, Integer> branchLimitPerNode = new HashMap<String, Integer>();

//// ノードの描画位置を行ごとに保存するための構造
//HashMap<Integer, ArrayList<PVector>> nodePositionsPerRow = new HashMap<>();

//void setup() {
//  fullScreen();
//  colorMode(HSB, 360, 100, 100, 255);
//  reset();

//  setRowDistances();
//  defaultNodesLimit();
//  defaultLinesLimit();

//  noLoop();
//}

//void draw() {
//  background(255);
//  drawGrid();
//  nodeSet();
//  drawLine();
//}

//void reset() {
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      dist[x][y] = -1;
//      prev[x][y] = null;
//      nodechack[x][y] = false;
//      hasParent[x][y] = false;
//      visited[x][y] = false;
//    }
//  }
//  maxDist = 0;
//  nodeLimitPerDist.clear();
//  branchLimitPerDist.clear();
//  branchLimitPerNode.clear();
//  nodePositionsPerRow.clear();
//}

//// 行ごとに距離を割り当てる（行ベース構造）
//void setRowDistances() {
//  for (int y = 0; y < rows; y++) {
//    for (int x = 0; x < cols; x++) {
//      dist[x][y] = y;
//      visited[x][y] = true;
//      if (y > maxDist) maxDist = y;
//    }
//  }
//}

//// デフォルト：距離ごとのノード上限
//void defaultNodesLimit() {
//  nodeLimitPerDist.put(0, 1);
//  for (int i = 1; i <= maxDist; i++) {
//    nodeLimitPerDist.put(i, (int)random(1, 5));
//  }
//}

//// デフォルト：ノードごとの線の数制限
//void defaultLinesLimit() {
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      String key = x + "," + y;
//      branchLimitPerNode.put(key, (int)random(1, 5));
//    }
//  }
//}

//void drawGrid() {
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      int d = dist[x][y];
//      if (d >= 0) {
//        fill(map(d, 0, maxDist, 0, 255), 100, 200);
//      } else {
//        fill(0);
//      }
//      stroke(0);
//      rect(x * cellSize, y * cellSize, cellSize, cellSize);

//      if (d >= 0) {
//        fill(0);
//        textAlign(CENTER, CENTER);
//        text(d, x * cellSize + cellSize / 2, y * cellSize + cellSize / 2);
//      }
//    }
//  }
//}

//// ノードの描画と位置を中央寄せで計算・記憶
//void nodeSet() {
//  HashMap<Integer, Integer> nodeCounts = new HashMap<Integer, Integer>();
//  HashMap<Integer, ArrayList<Integer>> nodesPerRowX = new HashMap<Integer, ArrayList<Integer>>();

//  // 各行のノード候補リストを初期化
//  for (int y = 0; y < rows; y++) {
//    nodesPerRowX.put(y, new ArrayList<Integer>());
//  }

//  // ノード決定と行ごとのノードx座標リスト作成
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      int d = dist[x][y];
//      if (d < 0) continue;

//      int currentCount = nodeCounts.getOrDefault(d, 0);
//      int limit = nodeLimitPerDist.getOrDefault(d, 999);

//      if (currentCount < limit) {
//        nodechack[x][y] = true;
//        nodeCounts.put(d, currentCount + 1);
//        nodesPerRowX.get(y).add(x);
//      } else {
//        nodechack[x][y] = false;
//      }
//    }
//  }

//  nodePositionsPerRow.clear();

//  // 各行のノード位置を中央寄せで計算し描画
//  for (int y = 0; y < rows; y++) {
//    ArrayList<Integer> xs = nodesPerRowX.get(y);
//    int n = xs.size();
//    if (n == 0) continue;

//    float totalWidth = (n - 1) * cellSize;
//    float startX = width / 2 - totalWidth / 2;

//    ArrayList<PVector> posList = new ArrayList<>();

//    for (int i = 0; i < n; i++) {
//      int x = xs.get(i);
//      float drawX = startX + i * cellSize + cellSize / 2;
//      float drawY = y * cellSize + cellSize / 2;
//      posList.add(new PVector(drawX, drawY));

//      fill(y == 0 ? color(60, 100, 100) : color(0, 0, 100));
//      ellipse(drawX, drawY, cellSize / 2, cellSize / 2);
//    }

//    nodePositionsPerRow.put(y, posList);
//  }
//}

//// 線の描画（ノードの中央寄せ位置を使用）
//void drawLine() {
//  class Node {
//    PVector pos;
//    int dist;
//    int x, y; // 元の座標

//    Node(PVector pos, int dist, int x, int y) {
//      this.pos = pos;
//      this.dist = dist;
//      this.x = x;
//      this.y = y;
//    }
//  }

//  ArrayList<Node> allNodes = new ArrayList<Node>();
//  HashMap<Integer, ArrayList<Node>> distMap = new HashMap<Integer, ArrayList<Node>>();
//  HashMap<String, Integer> branchCounts = new HashMap<String, Integer>();

//  // nodechack で選ばれたノードからNodeオブジェクト作成し、distMapに格納
//  for (int y = 0; y < rows; y++) {
//    if (!nodePositionsPerRow.containsKey(y)) continue;
//    ArrayList<PVector> posList = nodePositionsPerRow.get(y);

//    // y行のノードのx座標リスト（元のx値）を取得
//    ArrayList<Integer> xsInRow = new ArrayList<>();
//    for (int x = 0; x < cols; x++) {
//      if (nodechack[x][y]) xsInRow.add(x);
//    }

//    for (int i = 0; i < posList.size(); i++) {
//      int xOrig = xsInRow.get(i);
//      PVector pos = posList.get(i);
//      Node node = new Node(pos.copy(), dist[xOrig][y], xOrig, y);
//      allNodes.add(node);
//      if (!distMap.containsKey(node.dist)) distMap.put(node.dist, new ArrayList<Node>());
//      distMap.get(node.dist).add(node);
//    }
//  }

//  for (Node a : allNodes) {
//    if (a.dist > 0 && !hasParent[a.x][a.y]) {
//      continue; // 親ノードがないならスキップ
//    }

//    if (!distMap.containsKey(a.dist + 1)) continue;
//    ArrayList<Node> nextNodes = new ArrayList<Node>(distMap.get(a.dist + 1));
//    Collections.shuffle(nextNodes);

//    String keyA = a.x + "," + a.y;
//    int countA = branchCounts.getOrDefault(keyA, 0);
//    int limitA = branchLimitPerNode.getOrDefault(keyA, 999);

//    boolean connected = false;

//    for (Node b : nextNodes) {
//      if (countA >= limitA) break;

//      String keyB = b.x + "," + b.y;
//      int countB = branchCounts.getOrDefault(keyB, 0);
//      int limitB = branchLimitPerNode.getOrDefault(keyB, 999);

//      if (countB >= limitB) continue;

//      // 線の色：階層によって色相を変えて視覚化
//      float hueVal = map(a.dist, 0, maxDist, 0, 360);
//      stroke(hueVal, 80, 100, 200);
//      strokeWeight(2);
//      line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);

//      countA++;
//      branchCounts.put(keyA, countA);
//      branchCounts.put(keyB, countB + 1);
//      hasParent[b.x][b.y] = true;

//      connected = true;
//    }

//    //// 補助線（つながらなかった場合）※必要なら残す
//    //if (!connected) {
//    //  for (Node b : nextNodes) {
//    //    if (!hasParent[b.x][b.y]) {
//    //      float hueVal = map(a.dist, 0, maxDist, 0, 360);
//    //      stroke(hueVal, 30, 90, 50);
//    //      strokeWeight(2);
//    //      line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);

//    //      branchCounts.put(keyA, branchCounts.getOrDefault(keyA, 0) + 1);
//    //      branchCounts.put(b.x + "," + b.y, branchCounts.getOrDefault(b.x + "," + b.y, 0) + 1);
//    //      hasParent[b.x][b.y] = true;
//    //      break;
//    //    }
//    //  }
//    //}
//  }
//}

//void keyPressed() {
//  if (key == 'r' || key == 'R') {
//    reset();
//    setRowDistances();
//    //defaultNodesLimit();
//    //defaultLinesLimit();
    
//    cloudNodesLimit();
//    cloudLinesLimit();
//    redraw();
//  }
//}
