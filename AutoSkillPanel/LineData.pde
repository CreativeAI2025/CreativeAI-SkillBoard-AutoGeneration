ArrayList<Node> lineData = new ArrayList<>();//ラインデータの保存
ArrayList<int[]> connections = new ArrayList<int[]>();// IDの遷移を記録

int getBranchCountFromDistribution(int nodeSum) {//今の枝数を受け取り、確率に基づいて次の枝数を決める関数
  float[] probs = linelimitPerRow.getOrDefault(nodeSum, new float[]{0.0});// その階層での枝数の確率分布を入れる
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和
  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) return i;//枝の本数を返す
  }
  return probs.length - 1;//枝の本数を返す
}

// その階層のノード数でノードに生える枝数を決める
void initializeNodes() {
  lineData.clear();
  int id = 0;
  for (int i = 0; i < rows; i++) {
    for (int n = 0; n < nodelimitPerRow.get(i); n++) {
      if (i <= 0) lineData.add(new Node(id, 2));//初期状態
      if (0 < i) lineData.add(new Node(id, getBranchCountFromDistribution(nodelimitPerRow.get(i))));
      //println(id, nodelimitPerRow.get(i));
      id++;
    }
    //println("ID:" + lineData.get(i).getId() + "枝：" + lineData.get(i).getBranch());
  }
}

//入力の個数を数えて出力数を決める
int input_for_out(int branch, int nowid) {
  int input = 0;
  int nextTrueInput = 0;

  for (int[] pair : connections) {
    int from = pair[0];
    int to = pair[1];

    if (nowid == to || nowid == from) {
      input++;
    }
  }

  return branch - input;
}

HashMap<Integer, Integer> branchNum = new HashMap<>();
void branchNumCheck() {

  for (int i = 0; i < nodeSum; i++) {
    int branch = 0;
    for (int[] pair : connections) {
      int from = pair[0];
      int to = pair[1];
      if (to == i || from == i) branch++;
    }
    branchNum.put(i, branch);
    //println(i, branch);
  }
}

//void connectRange(int nowStart, int nowEnd, int beforeStart, int nextEnd) {
//  for (int i = nowStart; i <= nowEnd; i++) {


//    int branchCount = lineData.get(i).getBranch();
//    int outputCount = input_for_out(branchCount, i);

//    HashSet<Integer> used = new HashSet<>(); // j の重複防止セット
//    int tries = 0;

//    while (used.size() < outputCount) {
//      int j = 0;

//      j = (int) random(nowEnd + 1, nextEnd + 1); // nowEnd ~ nextEnd のランダム

//      if (!used.contains(j) && i != j && branchNum.get(j) < lineData.get(j).getBranch()) {
//        connections.add(new int[]{i, j});
//        used.add(j);
//        //println(i, outputCount);
//        println(i, outputCount, j, branchNum.get(j) + 1, lineData.get(j).getBranch());
//      }

//      tries++;
//      if (tries > 1000) { // 無限ループ防止
//        //println("Too many tries at node " + i);
//        break;
//      }
//    }
//  }
//}

HashSet<String> usedConnections = new HashSet<>(); // 使用済みパターンの格納

void firstconnectRange(int nowStart, int nowEnd, int beforeStart, int beforeEnd) {
  for (int i = nowStart; i <= nowEnd; i++) {


    int branchCount = lineData.get(i).getBranch();

    HashSet<Integer> used = new HashSet<>(); // すでにつかったIDの重複防止セット

    int j = 0;

    do {
      j = (int) random(beforeStart, beforeEnd + 1); // nowEnd ~ nextEnd のランダム(一つ下の階層)
    } while (used.contains(j));
    used.add(j);
    connections.add(new int[]{j, i});
    String key = j + "-" + i; // 接続パターンを文字列化
    usedConnections.add(key); // 使用済みとして登録
  }
}

void secondconnectRange(int nowStart, int nowEnd, int beforeStart, int beforeEnd) {
  for (int i = nowStart; i <= nowEnd; i++) {

    int branchCount = lineData.get(i).getBranch();
    int outputCount = branchCount - branchNum.get(i);

    HashSet<Integer> used = new HashSet<>(); // ノード i に対する接続先重複防止

    int tries = 0;

    while (outputCount > 0) {
      int j = (int) random(nowStart, beforeEnd + 1);

      String key = j + "-" + i; // 接続パターンを文字列化

      if (!used.contains(j) && i != j && branchNum.get(j) < lineData.get(j).getBranch() && !usedConnections.contains(key)) {

        connections.add(new int[]{j, i});
        used.add(j);
        usedConnections.add(key); // 使用済みとして登録

        branchNum.put(j, branchNum.get(j) + 1);
        branchNum.put(i, branchNum.get(i) + 1);

        outputCount--;

        // println("Connect: " + j + " -> " + i + " (usedConnections added: " + key + ")");
      }

      tries++;
      if (tries > 1000) {
        // println("Too many tries at node " + i);
        break;
      }
    }
  }
}



// 接続を作成
void generateRandomConnections() {
  connections.clear();  // 前回の接続をリセット
  usedConnections.clear();
  lineData.clear();
  int nodesum = nodeSum - 1;
  int sum = 0;
  int bsum = 0;
  initializeNodes();// ノードに生える枝数を決める

  for (int y = rows - 1; y > 0; y--) {
    //if (y > 0) println(nodesum - nodelimitPerRow.get(y) + 1, nodesum, nodesum - nodelimitPerRow.get(y) - nodelimitPerRow.get(y - 1) + 1, nodesum - nodelimitPerRow.get(y));
    if (y > 0) firstconnectRange(nodesum - nodelimitPerRow.get(y) + 1, nodesum, nodesum - nodelimitPerRow.get(y) - nodelimitPerRow.get(y - 1) + 1, nodesum - nodelimitPerRow.get(y));
    bsum = nodesum;
    nodesum -= nodelimitPerRow.get(y);
  }

  branchNumCheck();

  nodesum = nodeSum - 1;
  bsum = 0;

  for (int y = rows - 1; y > 0; y--) {
    //if (y > 0) println(nodesum - nodelimitPerRow.get(y) + 1, nodesum, nodesum - nodelimitPerRow.get(y) - nodelimitPerRow.get(y - 1) + 1, nodesum - nodelimitPerRow.get(y));
    if (y > 0) secondconnectRange(nodesum - nodelimitPerRow.get(y) + 1, nodesum, nodesum - nodelimitPerRow.get(y) - nodelimitPerRow.get(y - 1) + 1, nodesum - nodelimitPerRow.get(y));
    bsum = nodesum;
    nodesum -= nodelimitPerRow.get(y);
  }

  //for (int y = 0; y < rows; y++) {
  //  //if (y < rows - 1) println(sum, sum + nodelimitPerRow.get(y) - 1,bsum, sum + + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
  //  //if (y < rows - 1) connectRange(sum, sum + nodelimitPerRow.get(y) - 1, bsum, sum + nodelimitPerRow.get(y) + nodelimitPerRow.get(y + 1) - 1);
  //  bsum = sum;
  //  sum += nodelimitPerRow.get(y);
  //}
}
