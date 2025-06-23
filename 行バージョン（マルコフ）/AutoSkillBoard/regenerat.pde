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

void drawAdditionalLinesFor(ArrayList<String> keysToConnect) {//特定ノードのみ線を引く処理
  HashMap<String, Integer> branchCounts = new HashMap<>();

  for (String keyA : keysToConnect) {
    String[] parts = keyA.split(",");
    int ax = int(parts[0]);
    int ay = int(parts[1]);

    int d = dist[ax][ay];
    if (!nodePositionsPerRow.containsKey(d + 1)) continue;

    ArrayList<Node> nextNodes = new ArrayList<>();
    for (int i = 0; i < nodePositionsPerRow.get(d + 1).size(); i++) {
      PVector pos = nodePositionsPerRow.get(d + 1).get(i);
      int bx = i; // 同じ順番で生成された仮定
      String keyB = bx + "," + (d + 1);
      Node b = new Node(pos.copy(), d + 1, bx, d + 1);
      nextNodes.add(b);
    }

    Collections.shuffle(nextNodes);
    PVector aPos = nodePositionsPerRow.get(d).get(ax); // 自分の描画位置

    int countA = 0;
    int limitA = branchLimitPerNode.getOrDefault(keyA, 999);

    for (Node b : nextNodes) {
      if (countA >= limitA) break;

      String keyB = b.x + "," + b.y;

      // 線を描画
      float hueVal = map(d, 0, maxDist, 0, 360);
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

boolean hasIsolatedNodes() {
  for (String key : nodeColors.keySet()) {
    // 入力が0かつ行が0でない（スタートノード以外）
    int inC = inDegreeMap.getOrDefault(key, 0);
    if (inC == 0 && !key.endsWith(",0")) {
      return true;
    }
  }
  return false;
}
