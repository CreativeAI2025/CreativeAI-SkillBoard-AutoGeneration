void setupBranchingDistributionFromData() {
  // 入力1のとき → 出力1: 50%, 出力2: 30%, 出力3: 20%
  branchProbByInDegree.put(0, new float[]{0, 0, 0, 0, 0, 0, 0});
  branchProbByInDegree.put(1, new float[]{0.01, 0.000, 0.123, 0.246, 0.140, 0.000, 0.018});
  branchProbByInDegree.put(2, new float[]{0, 0.028, 0.008, 0.272, 0.192, 0.016, 0.484});
  branchProbByInDegree.put(3, new float[]{0, 0.114, 0.553, 0.000, 0.000, 0.008, 0.325});
  branchProbByInDegree.put(4, new float[]{0, 0.095, 0.571, 0.000, 0.333, 0.000, 0.000});
  branchProbByInDegree.put(5, new float[]{0, 0, 0.8, 0.2, 0, 0, 0});
  branchProbByInDegree.put(6, new float[]{0, 0.006, 0.747, 0.247, 0.000, 0.000, 0.000});
}


//  枝0  枝1  枝2  枝3  枝4  枝5  枝6  合計
//枝1  0.474,  0.000,  0.123,  0.246,  0.140,  0.000,  0.018  1
//枝2  0.000  0.028  0.008  0.272  0.192  0.016  0.484  1
//枝３  0.000  0.114  0.553  0.000  0.000  0.008  0.325  1
//枝４  0.000  0.095  0.571  0.000  0.333  0.000  0.000  1
//枝５  0.000  0.000  0.800  0.200  0.000  0.000  0.000  1
//枝６  0.000  0.006  0.747  0.247  0.000  0.000  0.000  1

float[] mpProbabilities = new float[] {
  0.05, // MP=1 の確率5%
  0.10, // MP=2 の確率10%
  0.15, // MP=3 の確率15%
  0.20, // MP=4 の確率20%
  0.20, // MP=5 の確率20%
  0.10, // MP=6 の確率10%
  0.08, // MP=7 の確率8%
  0.07, // MP=8 の確率7%
  0.03, // MP=9 の確率3%
  0.02  // MP=10 の確率2%
};

void mpData() {
  // 階層別 MP 分布準備
  mpDistByLevel = new HashMap<>();
  mpDistByLevel.put(0, new float[]{0.4f, 0.3f, 0.1f, 0.1f, 0.05f, 0.03f, 0.01f, 0.005f, 0.003f, 0.002f});
  for (int i=1; i<=4; i++) {
    mpDistByLevel.put(i, new float[]{0.05f, 0.1f, 0.15f, 0.2f, 0.2f, 0.15f, 0.1f, 0.03f, 0.015f, 0.005f});
  }
  for (int i=5; i<rows; i++) {
    mpDistByLevel.put(i, new float[]{0.01f, 0.02f, 0.03f, 0.05f, 0.1f, 0.2f, 0.25f, 0.2f, 0.1f, 0.04f});
  }

  // 色別 MP 分布準備
  mpDistByColorType = new HashMap<>();
  mpDistByColorType.put("red", new float[]{0.05f, 0.1f, 0.15f, 0.2f, 0.25f, 0.15f, 0.05f, 0.03f, 0.015f, 0.005f});
  mpDistByColorType.put("blue", new float[]{0.2f, 0.2f, 0.15f, 0.1f, 0.1f, 0.1f, 0.07f, 0.05f, 0.02f, 0.01f});
}

void inputPerBranch() {//入力の枝の制限
  maxInputPerNode.put("0,6", 1);
  maxInputPerNode.put("1,6", 1);
  
  //階層による制限
    //for (int x = 0; x < cols; x++) {
  //  for (int y = 0; y < rows; y++) {
  //    if (nodechack[x][y]) {
  //      String key = x + "," + y;

  //      // y行に応じて制限を変える例
  //      if (y < rows / 3) maxInputPerNode.put(key, 2);
  //      else if (y < rows * 2 / 3) maxInputPerNode.put(key, 2);
  //      else maxInputPerNode.put(key, 1);
  //    }
  //  }
  //}
}
