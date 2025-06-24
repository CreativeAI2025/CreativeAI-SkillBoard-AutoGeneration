void regenerateDisconnectedNodes() {//入力が0のノードを検出して再設定
  ArrayList<String> isolatedNodes = new ArrayList<>();

  for (String key : nodeColors.keySet()) {
    int inC = inDegreeMap.getOrDefault(key, 0);
    //int outC = outDegreeMap.getOrDefault(key, 0);
    if (inC == 0) {
      isolatedNodes.add(key);
    }
  }

  for (String key : isolatedNodes) {
    // 入力が0の場合、再度branch数を確率で決定
    int branchLimit = getBranchCountFromDistribution(0); // 入力0を使う
    branchLimitPerNode.put(key, branchLimit);
  }

  // もう一度 drawLine 相当の出力接続だけ行う（追記用）
  drawAdditionalLinesFor(isolatedNodes);
}

void drawAdditionalLinesFor(ArrayList<String> keysToConnect) {
  HashMap<String, Integer> branchCounts = new HashMap<>();

  for (String keyA : keysToConnect) {
    String[] parts = keyA.split(",");
    int ax = int(parts[0]);
    int ay = int(parts[1]);

    int d = dist[ax][ay];
    if (!nodePositionsPerRow.containsKey(d + 1)) continue;

    // 次の行のx座標リスト（nodechackベース）を取得
    ArrayList<Integer> xsNextRow = new ArrayList<>();
    for (int x = 0; x < cols; x++) {
      if (nodechack[x][d + 1]) xsNextRow.add(x);
    }

    // 現在行のx座標リスト
    ArrayList<Integer> xsCurrentRow = new ArrayList<>();
    for (int x = 0; x < cols; x++) {
      if (nodechack[x][d]) xsCurrentRow.add(x);
    }

    // 今のノードの描画インデックス取得
    int aIndex = xsCurrentRow.indexOf(ax);
    if (aIndex == -1) continue; // 念のため

    PVector aPos = nodePositionsPerRow.get(d).get(aIndex);

    ArrayList<Node> nextNodes = new ArrayList<>();
    for (int i = 0; i < xsNextRow.size(); i++) {
      int bx = xsNextRow.get(i);
      PVector pos = nodePositionsPerRow.get(d + 1).get(i);

      int mp = (int)random(1, 11); // ノードごとにMPを生成

      String keyB = bx + "," + (d + 1);
      Node b = new Node(pos.copy(), d + 1, bx, d + 1, mp);
      nextNodes.add(b);

      mpMap.put(keyB, mp);
    }

    Collections.shuffle(nextNodes);

    int countA = 0;
    int limitA = branchLimitPerNode.getOrDefault(keyA, 999);

    for (Node b : nextNodes) {
      if (countA >= limitA) break;

      String keyB = b.x + "," + b.y;

      // 線を描画
      float hueVal = map(d, 0, rows, 0, 360);
      stroke(hueVal, 80, 100, 200);
      strokeWeight(2);
      line(aPos.x, aPos.y, b.pos.x, b.pos.y);

      // 出力・入力カウント
      outDegreeMap.put(keyA, outDegreeMap.getOrDefault(keyA, 0) + 1);
      inDegreeMap.put(keyB, inDegreeMap.getOrDefault(keyB, 0) + 1);

      countA++;
      branchCounts.put(keyA, countA);
    }
  }
}


boolean hasIsolatedNodes() {// 親の有無の判定
  for (String key : nodeColors.keySet()) {
    // 入力が0かつ行が0でない（スタートノード以外）
    int inC = inDegreeMap.getOrDefault(key, 0);
    if (inC == 0 && !key.endsWith(",0")) {
      return true;
    }
  }
  return false;
}
