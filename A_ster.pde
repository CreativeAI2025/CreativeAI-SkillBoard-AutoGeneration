//import java.util.*;

//int cols = 11;
//int rows = 11;
//int cellSize = 50;

//PVector start = new PVector(0, 0);
//PVector goal = new PVector(cols - 1, rows - 1); // ここはcols-1, rows-1に修正

//boolean[][] visited = new boolean[cols][rows];
//int[][] dist = new int[cols][rows];
//PVector[][] prev = new PVector[cols][rows];
//boolean[][] hasParent = new boolean[cols][rows];

//PVector[] directions = {
//  new PVector(0, -1), new PVector(0, 1),
//  new PVector(-1, 0), new PVector(1, 0),
//  new PVector(-1, -1), new PVector(1, -1),
//  new PVector(-1, 1), new PVector(1, 1)
//};

//HashMap<Integer, Integer> nodeLimitPerDist = new HashMap<>();
//HashMap<Integer, Integer> branchLimitPerDist = new HashMap<>();

//boolean[][] nodechack = new boolean[cols][rows];
//int maxDist = 0;

//void setup() {
//  fullScreen();

//  defaultNodesLimit();
//  defaultLinesLimit();

//  reset();
//  startPosAStar();
//  AStarSearch();
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
//      visited[x][y] = false;
//    }
//  }
//}

//// Nodeクラス（A*用）
//class Node implements Comparable<Node> {
//  int x, y;
//  int g; // スタートからのコスト
//  int h; // ヒューリスティック
//  int f; // g + h
//  Node parent;

//  Node(int x, int y, int g, int h, Node parent) {
//    this.x = x;
//    this.y = y;
//    this.g = g;
//    this.h = h;
//    this.f = g + h;
//    this.parent = parent;
//  }

//  // f値で優先度決定（小さいほうを優先）
//  public int compareTo(Node other) {
//    return Integer.compare(this.f, other.f);
//  }
//}

//// ヒューリスティック関数（マンハッタン距離）
//int heuristic(int x, int y) {
//  return (int)(Math.abs((int)goal.x - x) + Math.abs((int)goal.y - y));
//}


//PriorityQueue<Node> openSet;

//void startPosAStar() {
//  openSet = new PriorityQueue<>();
//  int h = heuristic((int)start.x, (int)start.y);
//  Node startNode = new Node((int)start.x, (int)start.y, 0, h, null);
//  openSet.add(startNode);
//  dist[startNode.x][startNode.y] = 0;
//  visited[startNode.x][startNode.y] = true;
//}

//void AStarSearch() {
//  while (!openSet.isEmpty()) {
//    Node current = openSet.poll();

//    // ゴールに到達したら終了
//    if (current.x == (int)goal.x && current.y == (int)goal.y) {
//      reconstructPath(current);
//      break;
//    }

//    for (PVector dir : directions) {
//      int nx = current.x + (int)dir.x;
//      int ny = current.y + (int)dir.y;

//      if (nx >= 0 && nx < cols && ny >= 0 && ny < rows) {
//        int tentative_g = current.g + 1; // 移動コストは1固定（必要に応じて変更可）
//        if (dist[nx][ny] == -1 || tentative_g < dist[nx][ny]) {
//          dist[nx][ny] = tentative_g;
//          int h = heuristic(nx, ny);
//          Node neighbor = new Node(nx, ny, tentative_g, h, current);
//          openSet.add(neighbor);
//          visited[nx][ny] = true;
//          prev[nx][ny] = new PVector(current.x, current.y);
//          if (tentative_g > maxDist) maxDist = tentative_g;
//        }
//      }
//    }
//  }
//}

//// ゴールから親ノードたどって経路を復元しhasParentをセット
//void reconstructPath(Node goalNode) {
//  Node current = goalNode;
//  while (current.parent != null) {
//    hasParent[current.x][current.y] = true;
//    current = current.parent;
//  }
//  hasParent[(int)start.x][(int)start.y] = true; // スタートもtrueに
//}

//void nodeSet() {
//  HashMap<Integer, Integer> nodeCounts = new HashMap<>();
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
//  class DrawNode {
//    PVector pos;
//    int dist;
//    int x, y;

//    DrawNode(PVector pos, int dist, int x, int y) {
//      this.pos = pos;
//      this.dist = dist;
//      this.x = x;
//      this.y = y;
//    }
//  }

//  ArrayList<DrawNode> allNodes = new ArrayList<>();
//  HashMap<Integer, ArrayList<DrawNode>> distMap = new HashMap<>();
//  HashMap<String, Integer> branchCounts = new HashMap<>();

//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      if (nodechack[x][y]) {
//        PVector center = new PVector(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2);
//        DrawNode node = new DrawNode(center, dist[x][y], x, y);
//        allNodes.add(node);

//        distMap.computeIfAbsent(dist[x][y], k -> new ArrayList<>());
//        distMap.get(dist[x][y]).add(node);
//      }
//    }
//  }

//  stroke(255, 180);
//  strokeWeight(2);

//  for (DrawNode a : allNodes) {
//    String keyA = a.x + "," + a.y;
//    int countA = branchCounts.getOrDefault(keyA, 0);
//    int limitA = branchLimitPerDist.getOrDefault(a.dist, 999);

//    if (a.dist != 0 && !hasParent[a.x][a.y]) continue;
//    if (!distMap.containsKey(a.dist + 1)) continue;

//    ArrayList<DrawNode> nextNodes = new ArrayList<>(distMap.get(a.dist + 1));
//    Collections.shuffle(nextNodes);

//    for (DrawNode b : nextNodes) {
//      if (countA >= limitA) break;

//      String keyB = b.x + "," + b.y;
//      int countB = branchCounts.getOrDefault(keyB, 0);
//      int limitB = branchLimitPerDist.getOrDefault(b.dist, 999);

//      if (countB >= limitB) continue;

//      stroke(colorForDist(a.dist) + 100,180);
//      line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
//      countA++;
//      branchCounts.put(keyA, countA);
//      branchCounts.put(keyB, countB + 1);
//      hasParent[b.x][b.y] = true;
//    }
//  }
//}

//color colorForDist(int dist) {
//  // 例：距離が大きくなるほど青→赤のグラデーション
//  float t = map(dist, 0, maxDist, 0, 1);
//  return lerpColor(color(0, 0, 255), color(255, 0, 0), t);
//}

//void keyPressed() {
//  if (key == 'r' || key == 'R') {
//    reset();
//    // 探索用データもリセット
//    //queue.clear();
//    openSet.clear();
    
//    // BFSなら
//    // startPosBFS();
//    // BFSSearch();
    
//    // A*なら
//    startPosAStar();
//    AStarSearch();
    
//    loop();  // drawループ再開
//  }
//}

//// 仮実装：距離ごとのノード・線数制限（全距離999に設定）
//void defaultNodesLimit() {
//  for (int i = 0; i < cols + rows; i++) {
//    nodeLimitPerDist.put(i, 999);
//  }
//}

//void defaultLinesLimit() {
//  for (int i = 0; i < cols + rows; i++) {
//    branchLimitPerDist.put(i, 3);
//  }
//}
