ArrayList<Node> lineData = new ArrayList<>();//ラインデータの保存
ArrayList<int[]> connections = new ArrayList<int[]>();// IDの遷移を記録

int getBranchCountFromDistribution(int branch) {//今の枝数を受け取り、確率に基づいて次の枝数を決める関数
  float[] probs = linelimitPerRow.getOrDefault(branch, new float[]{0.0});// その階層での枝数の確率分布を入れる
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和
  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) return i;//枝の本数を返す
  }
  return probs.length - 1;//枝の本数を返す
}

// ノードに生える枝数を決める
void initializeNodes(int nodeSum) {
  lineData.clear();
  for (int i = 0; i < nodeSum; i++) {
    if (i <= 0) lineData.add(new Node(i, 2));//初期状態
    if (0 < i) lineData.add(new Node(i, getBranchCountFromDistribution(lineData.get(i-1).getBranch())));
    //println("ID:" + lineData.get(i).getId() + "枝：" + lineData.get(i).getBranch());
  }
}

int input_for_out(int branch, int nowid) {//入力の個数を数えて出力数を決める
  int input = 0;

  if (nowid == 0) return branch;
  
  for (int[] pair : connections) {
    int from = pair[0];
    int to = pair[1];

    if (nowid == to) {
      input++;
    }
  }

  return branch - input;
}

void connectRange(int nowStart, int nowEnd, int beforeStart, int nextEnd) {
  for (int i = nowStart; i <= nowEnd; i++) {


    int branchCount = lineData.get(i).getBranch();
    int outputCount = input_for_out(branchCount, i);
    HashSet<Integer> used = new HashSet<>(); // j の重複防止セット
    int tries = 0;

    while (used.size() < outputCount) {
      int j = 0;
      
        j = (int) random(nowEnd + 1, nextEnd + 1); // nowEnd ~ nextEnd のランダム

      if (!used.contains(j) && i != j) {
        connections.add(new int[]{i, j});
        used.add(j);
      }

      tries++;
      if (tries > 1000) { // 無限ループ防止
        //println("Too many tries at node " + i);
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
  initializeNodes(nodeSum);// ノードに生える枝数を決める

  for (int y = 0; y < rows; y++) {

    //if (y < rows - 1) println(sum, sum + nodelimitPerRow.get(y) - 1,bsum, sum + + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    if (y < rows - 1) connectRange(sum, sum + nodelimitPerRow.get(y) - 1, bsum, sum + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
    bsum = sum;
    sum += nodelimitPerRow.get(y);
  }
}
