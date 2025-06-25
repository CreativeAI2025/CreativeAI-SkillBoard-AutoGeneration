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

//HashMap<Integer, Integer> nodeLimitPerDist = new HashMap<>();
//HashMap<Integer, Integer> branchLimitPerDist = new HashMap<>();
//HashMap<String, Integer> branchLimitPerNode = new HashMap<>();

//HashMap<Integer, ArrayList<PVector>> nodePositionsPerRow = new HashMap<>();

//// 動的描画用
//ArrayList<Connection> connections = new ArrayList<Connection>();
//int currentConnectionIndex = 0;

//class Node {
//  PVector pos;
//  int dist;
//  int x, y;
//  Node(PVector pos, int dist, int x, int y) {
//    this.pos = pos;
//    this.dist = dist;
//    this.x = x;
//    this.y = y;
//  }
//}

//class Connection {
//  Node a, b;
//  int dist;
//  Connection(Node a, Node b, int dist) {
//    this.a = a;
//    this.b = b;
//    this.dist = dist;
//  }
//}

//void setup() {
//  fullScreen();
//  colorMode(HSB, 360, 100, 100, 255);
//  reset();

//  setRowDistances();
//  cloudNodesLimit();
//  cloudLinesLimit();

//  loop();
//}

//void draw() {
//  background(300);
//  drawGrid();
//  nodeSet();

//  if (connections.isEmpty()) {
//    prepareConnections(); // 最初の一回だけ
//  }

//  drawNextConnection(); // 毎フレーム1本ずつ描画
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
//  branchLimitPerDist.clear();
//  branchLimitPerNode.clear();
//  nodePositionsPerRow.clear();
//  connections.clear();
//  currentConnectionIndex = 0;
//}

//void setRowDistances() {
//  for (int y = 0; y < rows; y++) {
//    for (int x = 0; x < cols; x++) {
//      dist[x][y] = y;
//      visited[x][y] = true;
//      if (y > maxDist) maxDist = y;
//    }
//  }
//}

//void cloudNodesLimit() {
//  nodeLimitPerDist.put(0, 1);
//  for (int i = 1; i <= maxDist; i++) {
//    nodeLimitPerDist.put(i, (int)random(1, 5));
//  }
//}

//void cloudLinesLimit() {
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      String key = x + "," + y;
//      branchLimitPerNode.put(key, (int)random(1, 4));
//    }
//  }
//}

//void drawGrid() {
//  float gridWidth = cols * cellSize;
//  float gridHeight = rows * cellSize;
//  float startX = width / 2 - gridWidth / 2;
//  float startY = 0;

//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      int d = dist[x][y];
//      fill(d >= 0 ? 255 : 0);
//      stroke(0);
//      rect(startX + x * cellSize, startY + y * cellSize, cellSize, cellSize);
//      if (d >= 0) {
//        fill(0);
//        textAlign(CENTER, CENTER);
//        text(d, startX + x * cellSize + cellSize / 2, startY + y * cellSize + cellSize / 2);
//      }
//    }
//  }
//}

//void nodeSet() {
//  HashMap<Integer, Integer> nodeCounts = new HashMap<>();
//  HashMap<Integer, ArrayList<Integer>> nodesPerRowX = new HashMap<>();
//  for (int y = 0; y < rows; y++) {
//    nodesPerRowX.put(y, new ArrayList<Integer>());
//  }

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
//  for (int y = 0; y < rows; y++) {
//    ArrayList<Integer> xs = nodesPerRowX.get(y);
//    int n = xs.size();
//    if (n == 0) continue;

//    float totalWidth = (n - 1) * cellSize;
//    float startX = width / 2 - totalWidth / 2;
//    float drawY = y * cellSize + cellSize / 2;

//    ArrayList<PVector> posList = new ArrayList<>();

//    for (int i = 0; i < n; i++) {
//      int x = xs.get(i);
//      float drawX = startX + i * cellSize + cellSize / 2;
//      posList.add(new PVector(drawX, drawY));

//      fill(y == 0 ? color(60, 100, 100) : color(0, 0, 100));
//      ellipse(drawX, drawY, cellSize / 2, cellSize / 2);
//    }

//    nodePositionsPerRow.put(y, posList);
//  }
//}

//void prepareConnections() {
//  ArrayList<Node> allNodes = new ArrayList<>();
//  HashMap<Integer, ArrayList<Node>> distMap = new HashMap<>();
//  HashMap<String, Integer> branchCounts = new HashMap<>();

//  for (int y = 0; y < rows; y++) {
//    if (!nodePositionsPerRow.containsKey(y)) continue;
//    ArrayList<PVector> posList = nodePositionsPerRow.get(y);
//    ArrayList<Integer> xsInRow = new ArrayList<>();
//    for (int x = 0; x < cols; x++) {
//      if (nodechack[x][y]) xsInRow.add(x);
//    }

//    for (int i = 0; i < posList.size(); i++) {
//      int xOrig = xsInRow.get(i);
//      PVector pos = posList.get(i);
//      Node node = new Node(pos.copy(), dist[xOrig][y], xOrig, y);
//      allNodes.add(node);
//      distMap.computeIfAbsent(node.dist, k -> new ArrayList<>()).add(node);
//    }
//  }

//  for (Node a : allNodes) {
//    if (a.dist > 0 && !hasParent[a.x][a.y]) continue;
//    if (!distMap.containsKey(a.dist + 1)) continue;
//    ArrayList<Node> nextNodes = new ArrayList<>(distMap.get(a.dist + 1));
//    Collections.shuffle(nextNodes);

//    String keyA = a.x + "," + a.y;
//    int countA = branchCounts.getOrDefault(keyA, 0);
//    int limitA = branchLimitPerNode.getOrDefault(keyA, 999);

//    for (Node b : nextNodes) {
//      String keyB = b.x + "," + b.y;
//      int countB = branchCounts.getOrDefault(keyB, 0);
//      int limitB = branchLimitPerNode.getOrDefault(keyB, 999);
//      if (countA < limitA && countB < limitB && !hasParent[b.x][b.y]) {
//        connections.add(new Connection(a, b, a.dist));
//        countA++;
//        branchCounts.put(keyA, countA);
//        branchCounts.put(keyB, countB + 1);
//        hasParent[b.x][b.y] = true;
//      }
//    }
//  }
//}

//void drawNextConnection() {
//  if (currentConnectionIndex >= connections.size()) {
//    noLoop();
//    return;
//  }

//  Connection conn = connections.get(currentConnectionIndex);
//  float hueVal = map(conn.dist, 0, maxDist, 0, 360);
//  stroke(hueVal, 80, 100, 200);
//  strokeWeight(2);
//  line(conn.a.pos.x, conn.a.pos.y, conn.b.pos.x, conn.b.pos.y);
//  currentConnectionIndex++;
//}

//void keyPressed() {
//  if (key == 'r' || key == 'R') {
//    reset();
//    setRowDistances();
//    cloudNodesLimit();
//    cloudLinesLimit();
//    loop();
//    redraw();
//  }
//}
