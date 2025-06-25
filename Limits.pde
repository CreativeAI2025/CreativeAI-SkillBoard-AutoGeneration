//void nodeLimits() {
//  // 各距離ごとのノード数制限
//  for (int i = 0; i < cols; i++) {
//    if (i < cols / 3) {//序盤
//      int r = randomInt(1, 3);
//      if (r < 3) nodeLimitPerDist.put(i, 1);
//    } else if (i < cols * 2 / 3) {//中盤
//      nodeLimitPerDist.put(i, randomInt(2, 4));
//    } else {//終盤
//      nodeLimitPerDist.put(i, randomInt(1, 2));
//    }
//  }
//}

//void lineLimits() {
//  // 各距離ごとの分岐数制限
//  for (int i = 0; i < cols; i++) {
//    if (i < cols / 3) {
//      branchLimitPerDist.put(i, 2);
//    } else if (i < cols * 2 / 3) {
//      branchLimitPerDist.put(i, 3);
//    } else {
//      branchLimitPerDist.put(i, randomInt(1, 2));
//    }
//  }
//}

//void defaultNodesLimit() {
//  nodeLimitPerDist.put(0, 1);
//  nodeLimitPerDist.put(1, 2);
//  nodeLimitPerDist.put(2, 4);
//  nodeLimitPerDist.put(3, 2);
//  nodeLimitPerDist.put(4, 7);
//  nodeLimitPerDist.put(5, 5);
//  nodeLimitPerDist.put(6, 7);
//  nodeLimitPerDist.put(7, 3);
//  nodeLimitPerDist.put(8, 1);
//  nodeLimitPerDist.put(9, 2);
//  nodeLimitPerDist.put(10, 1);
//}

//void defaultLinesLimit(){
//  branchLimitPerDist.put(0, 2);
//  branchLimitPerDist.put(1, 3);
//  branchLimitPerDist.put(2, 2);
//  branchLimitPerDist.put(3, 4);
//  branchLimitPerDist.put(4, 2);
//  branchLimitPerDist.put(5, 3);
//  branchLimitPerDist.put(6, 3);
//  branchLimitPerDist.put(7, 1);
//  branchLimitPerDist.put(8, 2);
//  branchLimitPerDist.put(9, 1);
//  branchLimitPerDist.put(10, 1);
//}
