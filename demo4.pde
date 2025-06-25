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

//void setup() {
//  fullScreen();
//  reset();

//  setRowDistances(); // ← 行ベースに変更
//  //assignRandomNodeLimits();
//  //assignRandomBranchLimits();

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

//// 行ごとのノード数制限
//void assignRandomNodeLimits() {
//  for (int d = 0; d <= maxDist; d++) {
//    nodeLimitPerDist.put(d, (int)random(2, 6)); // 2～5ノード
//  }
//}

//// ノード単位の枝数上限（ランダム）
//void assignRandomBranchLimits() {
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      String key = x + "," + y;
//      branchLimitPerNode.put(key, (int)random(1, 4)); // 1～3本
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

//void nodeSet() {
//  HashMap<Integer, Integer> nodeCounts = new HashMap<Integer, Integer>();
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      int d = dist[x][y];
//      if (d < 0) continue;

//      int currentCount = nodeCounts.getOrDefault(d, 0);
//      int limit = nodeLimitPerDist.getOrDefault(d, 999);

//      if (currentCount < limit) {
//        fill(d == 0 ? color(255, 255, 0) : color(255));
//        ellipse(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
//        nodechack[x][y] = true;
//        nodeCounts.put(d, currentCount + 1);
//      }
//    }
//  }
//}

//void drawLine() {
//  class Node {
//    PVector pos;
//    int dist;
//    int x, y;

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

//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      if (nodechack[x][y]) {
//        PVector center = new PVector(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2);
//        Node node = new Node(center, dist[x][y], x, y);
//        allNodes.add(node);

//        if (!distMap.containsKey(dist[x][y])) {
//          distMap.put(dist[x][y], new ArrayList<Node>());
//        }
//        distMap.get(dist[x][y]).add(node);
//      }
//    }
//  }

//  for (Node a : allNodes) {
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

//      stroke(map(a.dist, 0, maxDist, 0, 255), 100, 255 - map(a.dist, 0, maxDist, 0, 255));
//      strokeWeight(2);
//      line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);

//      countA++;
//      branchCounts.put(keyA, countA);
//      branchCounts.put(keyB, countB + 1);
//      hasParent[b.x][b.y] = true;

//      connected = true;
//    }

//    if (!connected) {
//      for (Node b : nextNodes) {
//        if (!hasParent[b.x][b.y]) {
//          stroke(255, 180);
//          strokeWeight(2);
//          line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
//          branchCounts.put(keyA, branchCounts.getOrDefault(keyA, 0) + 1);
//          branchCounts.put(b.x + "," + b.y, branchCounts.getOrDefault(b.x + "," + b.y, 0) + 1);
//          hasParent[b.x][b.y] = true;
//          break;
//        }
//      }
//    }
//  }
//}

//void keyPressed() {
//  if (key == 'r' || key == 'R') {
//    reset();
//    setRowDistances(); // 行ベースで再初期化
//    assignRandomNodeLimits();
//    assignRandomBranchLimits();
//    redraw();
//  }
//}
