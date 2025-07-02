HashMap<Integer, float[]> linelimitPerRow = new HashMap<>();//枝数の制限
ArrayList<int[]> connections = new ArrayList<int[]>();// IDの遷移を記録


int getBranchCountFromDistribution(int branch) {//今の数を受け取り、確率に基づいて次の枝数を決める関数
  float[] probs = linelimitPerRow.getOrDefault(branch, new float[]{0.0});// その階層での枝数の確率分布を入れる
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和
  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) return i;//枝の本数を返す
  }
  return probs.length - 1;//枝の本数を返す
}

// 事前に必要なノード数分だけNodeを作成して入れておく
void initializeNodes(int nodeSum) {
  lineData.clear();
  for (int i = 0; i < nodeSum; i++) {
    if (i <= 0) lineData.add(new Node(i, 2));//初期状態
    if (0 < i) lineData.add(new Node(i, getBranchCountFromDistribution(lineData.get(i-1).getBranch())));
    //println("ID:" + lineData.get(i).getId() + "枝：" + lineData.get(i).getBranch());
  }
}

////汎用接続関数：指定した範囲どうしをすべて接続
//void connectRange(int fromStart, int fromEnd, int toStart, int toEnd) {
//  for (int i = fromStart; i <= fromEnd; i++) {
//    for (int j = toStart; j <= toEnd; j++) {
//      Node fromNode = lineData.get(i);
//      Node toNode = lineData.get(j);

//      connections.add(new int[]{i, j});
//    }
//  }
//}

//void connectRange(int nowStart, int nowEnd, int beforeStart, int nextEnd) {
//  int count;
//  for (int i = nowStart; i <= nowEnd; i++) {
//    count = 0;
//    for (int j = beforeStart; j <= nextEnd; j++) {
//      if (lineData.get(i).getBranch() > count) {
//        connections.add(new int[]{i, j});
//        count++;
//      }
//    }
//  }
//}

void connectRange(int nowStart, int nowEnd, int beforeStart, int nextEnd) {
  for (int i = nowStart; i <= nowEnd; i++) {
    int branchCount = lineData.get(i).getBranch();
    HashSet<Integer> used = new HashSet<>(); // j の重複防止セット
    int tries = 0;

    while (used.size() < branchCount) {
      int j = (int) random(beforeStart, nextEnd + 1); // beforeStart ~ nextEnd のランダム
      if (!used.contains(j)) {
        connections.add(new int[]{i, j});
        used.add(j);
      }

      tries++;
      if (tries > 1000) { // 無限ループ防止
        println("Too many tries at node " + i);
        break;
      }
    }
  }
}


// 接続を作成
void generateRandomConnections() {
  connections.clear();  // 前回の接続をリセット
  lineData.clear();
  int sum = 0;
  int bsum = 0;
  initializeNodes(nodeSum);

  for (int y = 0; y < rows; y++) {

    if (y < rows - 1) println(sum, sum + nodelimitPerRow.get(y) - 1,bsum, sum + + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    if (y < rows - 1) connectRange(sum, sum + nodelimitPerRow.get(y) - 1,bsum, sum + + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    bsum = sum;
    sum += nodelimitPerRow.get(y); 
  }
}

void lineLimitSet() {//入力枝数に対して出力枝数の確率(最高枝数６)
  // 枝1のとき → 枝1: 50%, 枝2: 30%, 枝3: 20%
  linelimitPerRow.put(0, new float[]{0, 0, 0, 0, 0, 0, 0});
  linelimitPerRow.put(1, new float[]{0.1, 0.000, 0.123, 0.246, 0.140, 0.000, 0.018});
  linelimitPerRow.put(2, new float[]{0, 0.028, 0.008, 0.272, 0.192, 0.016, 0.484});
  linelimitPerRow.put(3, new float[]{0, 0.114, 0.553, 0.000, 0.000, 0.008, 0.325});
  linelimitPerRow.put(4, new float[]{0, 0.095, 0.571, 0.000, 0.333, 0.000, 0.000});
  linelimitPerRow.put(5, new float[]{0, 0, 0.8, 0.2, 0, 0, 0});
  linelimitPerRow.put(6, new float[]{0, 0.006, 0.747, 0.247, 0.000, 0.000, 0.000});
}
