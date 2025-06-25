//import java.util.*;

//int cols = 11;
//int rows = 11;
//int cellSize = 50;

//PVector start = new PVector(0, 0);
//PVector goal = new PVector(cols, rows);

//boolean[][] visited = new boolean[cols][rows];
//int[][] dist = new int[cols][rows];
//PVector[][] prev = new PVector[cols][rows];
//boolean[][] hasParent = new boolean[cols][rows];

//ArrayList<PVector> queue = new ArrayList<PVector>();

//PVector[] directions = {
//  new PVector(0, -1), new PVector(0, 1),
//  new PVector(-1, 0), new PVector(1, 0),
//  new PVector(-1, -1), new PVector(1, -1),
//  new PVector(-1, 1), new PVector(1, 1)
//};

//// グローバルに保持すべきマップ
//HashMap<Integer, Integer> nodeLimitPerDist = new HashMap<Integer, Integer>();
//HashMap<Integer, Integer> branchLimitPerDist = new HashMap<Integer, Integer>();

//// ★ノード単位の枝数上限制御用マップ（キー："x,y"）
//HashMap<String, Integer> branchLimitPerNode = new HashMap<>();

//boolean[][] nodechack = new boolean[cols][rows];
//int maxDist = 0;

//void setup() {
//  fullScreen();

//  //defaultNodesLimit();
//  //defaultLinesLimit();

//  // ノード単位の枝数上限設定例
//  // ノード(3,4)の枝数上限を2に設定
//  branchLimitPerNode.put("3,4", 2);
//  branchLimitPerNode.put("1,1", 1);  // 他にも必要なら追加

//  reset();
//  startPosBFS();
//  BFSSearch();
//}

//void draw() {
//  background(255);

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

//  nodeSet();
//  drawLine();
//  noLoop();
//}

//void reset() {
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      dist[x][y] = -1;
//      prev[x][y] = null;
//      nodechack[x][y] = false;
//      hasParent[x][y] = false;
//      visited[x][y] = false;  // visitedもリセット
//    }
//  }
//  maxDist = 0;
//  queue.clear();
//}

//void startPosBFS() {
//  queue.clear();
//  queue.add(start);
//  visited[(int)start.x][(int)start.y] = true;
//  dist[(int)start.x][(int)start.y] = 0;
//}

//void BFSSearch() {
//  while (!queue.isEmpty()) {
//    PVector current = queue.remove(0);
//    for (PVector dir : directions) {
//      int nx = (int)(current.x + dir.x);
//      int ny = (int)(current.y + dir.y);

//      if (nx >= 0 && nx < cols && ny >= 0 && ny < rows && !visited[nx][ny]) {
//        visited[nx][ny] = true;
//        dist[nx][ny] = dist[(int)current.x][(int)current.y] + 1;
//        prev[nx][ny] = current.copy();
//        queue.add(new PVector(nx, ny));

//        if (dist[nx][ny] > maxDist) {
//          maxDist = dist[nx][ny];
//        }
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
//        if (d != 0) fill(255);
//        if (d == 0) fill(255, 255, 0);
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

//  // 全ノード収集と距離ごと分類
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

//  strokeWeight(2);

//  for (Node a : allNodes) {
//    String keyA = a.x + "," + a.y;
//    int countA = branchCounts.getOrDefault(keyA, 0);

//    // ノード単位の枝数上限があれば使い、なければ距離ごとの上限
//    int limitA = branchLimitPerNode.getOrDefault(keyA, branchLimitPerDist.getOrDefault(a.dist, 999));

//    if (a.dist != 0 && !hasParent[a.x][a.y]) continue;
//    if (!distMap.containsKey(a.dist + 1)) continue;

//    ArrayList<Node> nextNodes = new ArrayList<Node>(distMap.get(a.dist + 1));
//    Collections.shuffle(nextNodes);

//    for (Node b : nextNodes) {
//      if (countA >= limitA) break;

//      String keyB = b.x + "," + b.y;
//      int countB = branchCounts.getOrDefault(keyB, 0);
//      int limitB = branchLimitPerNode.getOrDefault(keyB, branchLimitPerDist.getOrDefault(b.dist, 999));
//      if (countB >= limitB) continue;

//      // 線の色を階層ごとに変える例（お好みで）
//      stroke(255, 180);

//      // 線を引く
//      line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
//      countA++;
//      branchCounts.put(keyA, countA);
//      branchCounts.put(keyB, countB + 1);
//      hasParent[b.x][b.y] = true;
//    }
//  }
//}

//// ノード数制限の初期値設定例
//void defaultNodesLimit() {
//  for (int i = 0; i < rows + cols; i++) {
//    nodeLimitPerDist.put(i, 999);
//  }
//}

//// 枝数制限の初期値設定例
//void defaultLinesLimit() {
//  for (int i = 0; i < rows + cols; i++) {
//    branchLimitPerDist.put(i, 999);
//  }
//}

//// キーで再生成
//void keyPressed() {
//  if (key == 'r' || key == 'R') {
//    reset();
//    startPosBFS();
//    BFSSearch();
//    loop();
//  }
//}
