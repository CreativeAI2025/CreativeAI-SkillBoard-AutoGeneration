import java.util.*;
PFont font;//フォント

int cols = 11;//列
int rows = 11;//行
int cellSize = 75;//１マスの大きさ
int retryCount = 0;//再設置のカウント
int maxRetry = 1000;//再設置の最大回数
int globalMaxInput = 6;//入力の最大数

PVector[][] prev = new PVector[cols][rows];//実座標
boolean[][] nodechack = new boolean[cols][rows];//ノードの有無

int[][] dist = new int[cols][rows];//探索距離

HashMap<Integer, Integer> nodeLimitPerDist = new HashMap<>();//各階層のノード数の制限
HashMap<String, Integer> branchLimitPerNode = new HashMap<>();//各階層の枝数の制限
HashMap<String, Integer> maxInputPerNode = new HashMap<>();//枝の受入可能数の制限
HashMap<Integer, ArrayList<PVector>> nodePositionsPerRow = new HashMap<>();//各階層のノードの探索座標の格納
HashMap<String, Integer> nodeColors = new HashMap<>(); //色の格納用
HashMap<String, Integer> inDegreeMap = new HashMap<>();//入力カウント
HashMap<String, Integer> outDegreeMap = new HashMap<>();//出力カウント
HashMap<Integer, float[]> branchProbByInDegree = new HashMap<>();//マルコフ過程による確率分布
HashMap<String, Integer> debugInDegreeMap = new HashMap<>();// 入力の数
HashMap<String, Integer> debugOutDegreeMap = new HashMap<>();// 出力の数
HashMap<String, Integer> mpMap = new HashMap<>();  // ノードのMP情報を保存
HashMap<Integer, float[]> mpDistByLevel = new HashMap<>();// MP配置の確率分布
HashMap<String, float[]> mpDistByColorType = new HashMap<>();// スキル配置の確率分布

void setup() {
  fullScreen();//画面サイズ
  colorMode(HSB, 360, 100, 100, 255);

  // 日本語を含むフォントを指定
  font = createFont("MS Gothic", 16);
  textFont(font);

  mpData();

  reset();
  inputPerBranch();
  setRowDistances();
  cloudNodesLimit();
  //cloudLinesLimit();
  setupBranchingDistributionFromData();
}

void draw() {
  background(300);
  drawGrid();
  nodeSet();
  drawLine();
  debugInDegreeMap = new HashMap<>(inDegreeMap);
  debugOutDegreeMap = new HashMap<>(outDegreeMap);
  applyBranchingBasedOnInDegree();
  regenerateDisconnectedNodes();

  if (showDebug) {
    drawDebugInfo();
  }

  println("Retry Count: " + retryCount);

  fill(0);
  textSize(20);
  text("Retry Count: " + retryCount, 100, 30);

  if (!hasIsolatedNodes() || retryCount > maxRetry) {
    noLoop();
  } else {
    retryCount++;
    reset();
    setRowDistances();
    cloudNodesLimit();
    setupBranchingDistributionFromData();  // 再生成準備
  }
}

void applyBranchingBasedOnInDegree() {// 入力数に基づいて、出力数を決める
  for (String key : nodeColors.keySet()) {
    int inCount = inDegreeMap.getOrDefault(key, 0);// 入力数
    int branchLimit = getBranchCountFromDistribution(inCount);//確率に基づいて出力数を決める関数
    branchLimitPerNode.put(key, branchLimit); //各階層の枝数の制限を追加
  }
}

int getBranchCountFromDistribution(int inDegree) {//確率に基づいて出力数を決める関数
  float[] probs = branchProbByInDegree.getOrDefault(inDegree, new float[]{1.0});// その階層での分岐確率を入れる
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和
  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) return i;//枝の本数を返す
  }
  return probs.length - 1;//枝の本数を返す
}

// MPをサンプリングする関数を定義
int getMpFromDistribution(float[] probs) {
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和
  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) return i + 1;//MPを返す
  }
  return probs.length;//MPを返す
}


void reset() {//初期化
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      dist[x][y] = -1;
      prev[x][y] = null;
      nodechack[x][y] = false;
    }
  }

  maxInputPerNode.clear();

  inputPerBranch();

  branchLimitPerNode.clear();
  nodePositionsPerRow.clear();
  nodeColors.clear();
}

void setRowDistances() {//探索距離の設定
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      dist[x][y] = y;// 探索距離
    }
  }
}

void drawGrid() {
  float gridWidth = cols * cellSize;
  float gridHeight = rows * cellSize;
  float startX = width / 2 - gridWidth / 2;
  float startY = 0;

  for (int y = 0; y < rows; y++) {
    if (y >= 0) fill(255);
    else fill(0);
    stroke(0);
    rect(startX, startY + y * cellSize, cellSize * cols, cellSize);

      fill(0);
      text(y, startX + cellSize / 2, startY + y * cellSize + cellSize / 2);
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
        } else if (y == (int)rows / 3) {
          float r = random(1);
          if (r <= 1) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        } else if (y < rows * 2 / 3) {
          float r = random(1);
          if (r < 0.381) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        } else if (y == (int)rows * 2 / 3) {
          float r = random(1);
          if (r < 0.292) {
            c = color(0, 100, 100);     // 赤
          } else {
            c = color(240, 100, 100);   // 青
          }
          nodeColors.put(x + "," + y, c);
        } else {
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
  inDegreeMap.clear();
  outDegreeMap.clear();

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

      String key = xOrig + "," + y;

      // 色相を取得
      int c = nodeColors.get(key);
      float nodeHue = hue(c);

      // 色系に基づくMP分布を決定
      float[] distByColor;
      if (nodeHue >= 340 || nodeHue <= 20) {
        distByColor = mpDistByColorType.get("red");
      } else if (nodeHue >= 210 && nodeHue <= 250) {
        distByColor = mpDistByColorType.get("blue");
      } else {
        distByColor = new float[] {0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f};
      }

      // 階層yに対応する分布を取得
      float[] distByLevel = mpDistByLevel.getOrDefault(y, new float[] {0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f});

      // ２つの分布を掛け合わせて正規化
      float[] combinedDist = new float[distByLevel.length];
      float sum = 0;
      for (int j = 0; j < combinedDist.length; j++) {
        combinedDist[j] = distByLevel[j] * distByColor[j];
        sum += combinedDist[j];
      }
      for (int j = 0; j < combinedDist.length; j++) combinedDist[j] /= sum;

      // MP決定
      int mp = getMpFromDistribution(combinedDist);

      Node node = new Node(pos.copy(), dist[xOrig][y], xOrig, y, mp);
      allNodes.add(node);

      fill(0);
      textSize(12);
      textAlign(CENTER, CENTER);
      text("MP: " + node.mp, node.pos.x, node.pos.y + cellSize / 3);//MP表示

      // MPをマップに保存
      mpMap.put(key, mp);

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

      String keyB = b.x + "," + b.y;

      // 最新の入力数を取得
      int currentInput = inDegreeMap.getOrDefault(keyB, 0);

      // 入力数制限をチェック（これを超えるならスキップ）
      int maxInput = maxInputPerNode.getOrDefault(keyB, globalMaxInput);
      if (currentInput >= maxInput) {
        continue;
      }

      // 線を描画
      float hueVal = map(a.dist, 0, rows, 0, 360);
      stroke(hueVal, 80, 100, 200);
      strokeWeight(2);
      line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);

      // 出力・入力カウントの更新（ここで1加算）
      outDegreeMap.put(keyA, outDegreeMap.getOrDefault(keyA, 0) + 1);
      inDegreeMap.put(keyB, currentInput + 1);

      // 出力制限数を更新
      countA++;
      branchCounts.put(keyA, countA);

      // 入出力サンプル記録
      int inDeg = inDegreeMap.getOrDefault(keyB, 0);
      //int outDeg = outDegreeMap.getOrDefault(keyB, 0);
      //if (!inOutSamples.containsKey(inDeg)) {
      //  inOutSamples.put(inDeg, new ArrayList<Integer>());
      //}
      //inOutSamples.get(inDeg).add(outDeg);

      // 出力分岐数を確率で決める（まだ決まっていない場合のみ）
      if (!branchLimitPerNode.containsKey(keyB)) {
        int limit = getBranchCountFromDistribution(inDeg);
        branchLimitPerNode.put(keyB, limit);
      }
    }
  }
}

boolean showDebug = true;

void keyPressed() {
  if (key == 'r' || key == 'R') {
    reset();
    retryCount = 0;
    setRowDistances();
    cloudNodesLimit();
    setupBranchingDistributionFromData();
    //cloudLinesLimit();
    loop();
    redraw();
  }

  if (key == 'd' || key == 'D') {
    showDebug = !showDebug;
    redraw();
  }
}

void drawDebugInfo() {
  fill(0);
  textSize(14);
  int y = 100;
  text("---- ノードの入出力 ----", 100, y);
  y += 20;

  // keySet を並べ替え：y行 → x列の順
  ArrayList<String> sortedKeys = new ArrayList<>(nodeColors.keySet());

  Collections.sort(sortedKeys, new Comparator<String>() {
    public int compare(String a, String b) {
      String[] ap = a.split(",");
      String[] bp = b.split(",");
      int ax = Integer.parseInt(ap[0]);
      int ay = Integer.parseInt(ap[1]);
      int bx = Integer.parseInt(bp[0]);
      int by = Integer.parseInt(bp[1]);

      if (ay != by) return ay - by; // y優先（行順）
      return ax - bx;               // x昇順（列順）
    }
  }
  );

  // 並べた順で出力
  for (String key : sortedKeys) {
    int inC = debugInDegreeMap.getOrDefault(key, 0);
    int outC = debugOutDegreeMap.getOrDefault(key, 0);
    int mp = mpMap.getOrDefault(key, -1);
    text(key + " → 入力: " + inC + ", 出力: " + outC + ", MP: " + mp, 120, y);

    y += 20;
  }
}
