HashMap<Integer, float[]> linelimitPerRow = new HashMap<>();
ArrayList<int[]> connections = new ArrayList<int[]>();// IDの遷移を記録


int getBranchCountFromDistribution(int inDegree) {//入力数を受け取り、確率に基づいて出力数を決める関数
  float[] probs = linelimitPerRow.getOrDefault(inDegree, new float[]{1.0});// その階層での分岐確率を入れる
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和
  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) return i;//枝の本数を返す
  }
  return probs.length - 1;//枝の本数を返す
}

// 事前に必要なノード数分だけNodeを作成して入れておく
void initializeNodes(int totalNodes) {
  lineData.clear();
  for (int i = 0; i < totalNodes; i++) {
    lineData.add(new Node(i, 0, 0));
  }
}

// 汎用接続関数：指定した範囲どうしをすべて接続
//void connectRange(int fromStart, int fromEnd, int toStart, int toEnd) {
//  for (int i = fromStart; i <= fromEnd; i++) {
//    for (int j = toStart; j <= toEnd; j++) {
//      Node fromNode = lineData.get(i);
//      Node toNode = lineData.get(j);

//      fromNode.addOutput();
//      toNode.addInput();
      
//      connections.add(new int[]{i, j});
//    }
//  }
//}

void connectRange(int fromStart, int fromEnd, int toStart, int toEnd) {
  for (int i = fromStart; i <= fromEnd; i++) {
    Node fromNode = lineData.get(i);

    // 出力先候補を作成
    ArrayList<Integer> toCandidates = new ArrayList<>();
    for (int j = toStart; j <= toEnd; j++) {
      toCandidates.add(j);
    }

    // 候補をシャッフル
    Collections.shuffle(toCandidates);

    // fromNode の入力数を取得（ここでは便宜上 inputCount を inDegree とみなす）
    int inDegree = fromNode.getInputCount();

    // 入力数に応じた分岐数（出力数）を確率的に決定
    int branchCount = getBranchCountFromDistribution(inDegree);
    branchCount = min(branchCount, toCandidates.size()); // 安全のため候補数と比較

    for (int b = 0; b < branchCount; b++) {
      int j = toCandidates.get(b); // シャッフルされた候補から選ぶ
      Node toNode = lineData.get(j);

      // 出力・入力のカウントを更新
      fromNode.addOutput();
      toNode.addInput();

      // 接続を記録
      connections.add(new int[]{i, j});
    }
  }
}

// 接続を作成
void generateRandomConnections() {
  connections.clear();  // 前回の接続をリセット
  lineData.clear();
  int sum = 0;

  initializeNodes(nodeSum);
  for (int y = 0; y < rows; y++) {

    //if(y < rows - 1) println(sum, sum + nodelimitPerRow.get(y) - 1, sum + nodelimitPerRow.get(y), sum + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    if (y < rows - 1) connectRange(sum, sum + nodelimitPerRow.get(y) - 1, sum + nodelimitPerRow.get(y), sum + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    sum += nodelimitPerRow.get(y);
  }
}

void lineLimitSet() {//入力枝数に対して出力枝数の確率(最高6分岐)
  // 入力1のとき → 出力1: 50%, 出力2: 30%, 出力3: 20%
  linelimitPerRow.put(0, new float[]{0, 0, 0, 0, 0, 0, 0});
  linelimitPerRow.put(1, new float[]{0.1, 0.000, 0.123, 0.246, 0.140, 0.000, 0.018});
  linelimitPerRow.put(2, new float[]{0, 0.028, 0.008, 0.272, 0.192, 0.016, 0.484});
  linelimitPerRow.put(3, new float[]{0, 0.114, 0.553, 0.000, 0.000, 0.008, 0.325});
  linelimitPerRow.put(4, new float[]{0, 0.095, 0.571, 0.000, 0.333, 0.000, 0.000});
  linelimitPerRow.put(5, new float[]{0, 0, 0.8, 0.2, 0, 0, 0});
  linelimitPerRow.put(6, new float[]{0, 0.006, 0.747, 0.247, 0.000, 0.000, 0.000});
}
