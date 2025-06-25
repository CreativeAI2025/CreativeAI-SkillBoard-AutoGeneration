void setupBranchingDistributionFromData() {
  // 入力1のとき → 出力1: 50%, 出力2: 30%, 出力3: 20%
  branchProbByInDegree.put(0, new float[]{0,0,0,0,0,0,0});
  branchProbByInDegree.put(1, new float[]{0.01,  0.000,  0.123,  0.246,  0.140,  0.000,  0.018});
  branchProbByInDegree.put(2, new float[]{0, 0.028,0.008,  0.272,  0.192,  0.016,  0.484});
  branchProbByInDegree.put(3, new float[]{0, 0.114,0.553,  0.000,  0.000,  0.008,  0.325});
  branchProbByInDegree.put(4, new float[]{0, 0.095, 0.571,  0.000, 0.333,  0.000,  0.000});
  branchProbByInDegree.put(5, new float[]{0, 0, 0.8, 0.2,0,0,0});
  branchProbByInDegree.put(6, new float[]{0, 0.006,0.747,0.247,0.000,0.000,0.000});
}


//  枝0  枝1  枝2  枝3  枝4  枝5  枝6  合計
//枝1  0.474,  0.000,  0.123,  0.246,  0.140,  0.000,  0.018  1
//枝2  0.000  0.028  0.008  0.272  0.192  0.016  0.484  1
//枝３  0.000  0.114  0.553  0.000  0.000  0.008  0.325  1
//枝４  0.000  0.095  0.571  0.000  0.333  0.000  0.000  1
//枝５  0.000  0.000  0.800  0.200  0.000  0.000  0.000  1
//枝６  0.000  0.006  0.747  0.247  0.000  0.000  0.000  1
