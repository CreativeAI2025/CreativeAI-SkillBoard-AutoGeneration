import java.util.*;

int cols = 11;
int rows = 11;
int cellSize = 50;

PVector[][] prev = new PVector[cols][rows];
boolean[][] nodechack = new boolean[cols][rows];
boolean[][] visited = new boolean[cols][rows];

int[][] dist = new int[cols][rows];
int maxDist = 0;

HashMap<Integer, Integer> nodeLimitPerDist = new HashMap<>();
HashMap<String, Integer> branchLimitPerNode = new HashMap<>();
HashMap<Integer, ArrayList<PVector>> nodePositionsPerRow = new HashMap<>();
HashMap<String, Integer> nodeColors = new HashMap<>(); // ← 色の格納用

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100, 255);
  reset();

  setRowDistances();
  cloudNodesLimit();
  cloudLinesLimit();

  noLoop();
}

void draw() {
  background(300);
  drawGrid();
  nodeSet();
  drawLine();
}

void reset() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      dist[x][y] = -1;
      prev[x][y] = null;
      nodechack[x][y] = false;
      visited[x][y] = false;
    }
  }
  maxDist = 0;
  branchLimitPerNode.clear();
  nodePositionsPerRow.clear();
  nodeColors.clear();
}

void setRowDistances() {
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      dist[x][y] = y;
      visited[x][y] = true;
      if (y > maxDist) maxDist = y;
    }
  }
}

void drawGrid() {
  float gridWidth = cols * cellSize;
  float gridHeight = rows * cellSize;
  float startX = width / 2 - gridWidth / 2;
  float startY = 0;

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      int d = dist[x][y];
      if (d >= 0) fill(255);
      else fill(0);
      stroke(0);
      rect(startX + x * cellSize, startY + y * cellSize, cellSize, cellSize);

      if (d >= 0) {
        fill(0);
        textAlign(CENTER, CENTER);
        text(d, startX + x * cellSize + cellSize / 2, startY + y * cellSize + cellSize / 2);
      }
    }
  }
}

void nodeSet() {
  HashMap<Integer, Integer> nodeCounts = new HashMap<>();
  HashMap<Integer, ArrayList<Integer>> nodesPerRowX = new HashMap<>();
  for (int y = 0; y < rows; y++) nodesPerRowX.put(y, new ArrayList<Integer>());

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      int d = dist[x][y];
      if (d < 0) continue;

      int currentCount = nodeCounts.getOrDefault(d, 0);
      int limit = nodeLimitPerDist.getOrDefault(d, 999);

      if (currentCount < limit) {
        nodechack[x][y] = true;
        nodeCounts.put(d, currentCount + 1);
        nodesPerRowX.get(y).add(x);

        // 色を確率で決定　赤：スキル、青：ステータス
        int c;
        if (y == 0) {
          c = color(60, 100, 100); // スタートノードだけは黄色で固定
          nodeColors.put(x + "," + y, c);
        } else if (y < rows / 3) {
          float r = random(1);
          if (r < 0.5) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        }else if (y == (int)rows / 3) {
          float r = random(1);
          if (r <= 1) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        }else if (y < rows * 2 / 3) {
          float r = random(1);
          if (r < 0.381) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        }else if (y == (int)rows * 2 / 3) {
          float r = random(1);
          if (r < 0.292) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        }else{
          float r = random(1);
          if (r < 0.388) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        }
      } else {
        nodechack[x][y] = false;
      }
    }
  }

  nodePositionsPerRow.clear();

  for (int y = 0; y < rows; y++) {
    ArrayList<Integer> xs = nodesPerRowX.get(y);
    int n = xs.size();
    if (n == 0) continue;

    float totalWidth = (n - 1) * cellSize;
    float startX = width / 2 - totalWidth / 2;
    float drawY = y * cellSize + cellSize / 2;

    ArrayList<PVector> posList = new ArrayList<>();

    for (int i = 0; i < n; i++) {
      int x = xs.get(i);
      float drawX = startX + i * cellSize + cellSize / 2;
      int nodeColor = nodeColors.get(x + "," + y);

      fill(nodeColor);
      stroke(0);
      ellipse(drawX, drawY, cellSize / 2, cellSize / 2);

      posList.add(new PVector(drawX, drawY));
    }

    nodePositionsPerRow.put(y, posList);
  }
}

void drawLine() {
  class Node {
    PVector pos;
    int dist;
    int x, y;

    Node(PVector pos, int dist, int x, int y) {
      this.pos = pos;
      this.dist = dist;
      this.x = x;
      this.y = y;
    }
  }

  ArrayList<Node> allNodes = new ArrayList<>();
  HashMap<Integer, ArrayList<Node>> distMap = new HashMap<>();
  HashMap<String, Integer> branchCounts = new HashMap<>();

  for (int y = 0; y < rows; y++) {
    if (!nodePositionsPerRow.containsKey(y)) continue;
    ArrayList<PVector> posList = nodePositionsPerRow.get(y);

    ArrayList<Integer> xsInRow = new ArrayList<>();
    for (int x = 0; x < cols; x++) {
      if (nodechack[x][y]) xsInRow.add(x);
    }

    for (int i = 0; i < posList.size(); i++) {
      int xOrig = xsInRow.get(i);
      PVector pos = posList.get(i);
      Node node = new Node(pos.copy(), dist[xOrig][y], xOrig, y);
      allNodes.add(node);
      if (!distMap.containsKey(node.dist)) distMap.put(node.dist, new ArrayList<>());
      distMap.get(node.dist).add(node);
    }
  }

  for (Node a : allNodes) {
    if (!distMap.containsKey(a.dist + 1)) continue;
    ArrayList<Node> nextNodes = new ArrayList<>(distMap.get(a.dist + 1));
    Collections.shuffle(nextNodes);

    String keyA = a.x + "," + a.y;
    int countA = branchCounts.getOrDefault(keyA, 0);
    int limitA = branchLimitPerNode.getOrDefault(keyA, 999);

    for (Node b : nextNodes) {
      if (countA >= limitA) break;

      float hueVal = map(a.dist, 0, maxDist, 0, 360);
      stroke(hueVal, 80, 100, 200);
      strokeWeight(2);
      line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);

      countA++;
      branchCounts.put(keyA, countA);
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    reset();
    setRowDistances();
    cloudNodesLimit();
    cloudLinesLimit();
    redraw();
  }
}
