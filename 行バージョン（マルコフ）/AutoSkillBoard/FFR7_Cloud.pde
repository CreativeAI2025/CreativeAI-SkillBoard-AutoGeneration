void cloudNodesLimit() {
  //if (!nodeLimitPerDist.isEmpty()) return;  // すでに設定済みなら何もしない
  
  nodeLimitPerDist.put(0, 1);
  nodeLimitPerDist.put(1, 2);
  nodeLimitPerDist.put(2, 4);
  nodeLimitPerDist.put(3, 2);
  nodeLimitPerDist.put(4, 7);
  nodeLimitPerDist.put(5, 5);
  nodeLimitPerDist.put(6, 7);
  nodeLimitPerDist.put(7, 3);
  nodeLimitPerDist.put(8, 1);
  nodeLimitPerDist.put(9, 2);
  nodeLimitPerDist.put(10, 1);
}

void cloudLinesLimit() {
  // y,x の順に反転
  branchLimitPerNode.put("0,0", 2);

  branchLimitPerNode.put("0,1", 2); // 1,0 -> 0,1
  branchLimitPerNode.put("1,1", 2);

  branchLimitPerNode.put("0,2", 1); // 2,0 -> 0,2
  branchLimitPerNode.put("1,2", 1); // 2,1 -> 1,2
  branchLimitPerNode.put("2,2", 1);
  branchLimitPerNode.put("3,2", 1); // 2,3 -> 3,2

  branchLimitPerNode.put("0,3", 4); // 3,0 -> 0,3
  branchLimitPerNode.put("1,3", 4); // 3,1 -> 1,3

  branchLimitPerNode.put("0,4", 1); // 4,0 -> 0,4
  branchLimitPerNode.put("1,4", 1); // 4,1 -> 1,4
  branchLimitPerNode.put("2,4", 1); // 4,2 -> 2,4
  branchLimitPerNode.put("3,4", 1); // 4,3 -> 3,4
  branchLimitPerNode.put("4,4", 1);
  branchLimitPerNode.put("5,4", 1); // 4,5 -> 5,4
  branchLimitPerNode.put("6,4", 1); // 4,6 -> 6,4

  branchLimitPerNode.put("0,5", 1); // 5,0 -> 0,5
  branchLimitPerNode.put("1,5", 3); // 5,1 -> 1,5
  branchLimitPerNode.put("2,5", 0); // 5,2 -> 2,5
  branchLimitPerNode.put("3,5", 3); // 5,3 -> 3,5
  branchLimitPerNode.put("4,5", 1); // 5,4 -> 4,5

  branchLimitPerNode.put("0,6", 1); // 6,0 -> 0,6
  branchLimitPerNode.put("1,6", 1); // 6,1 -> 1,6
  branchLimitPerNode.put("2,6", 1); // 6,2 -> 2,6
  branchLimitPerNode.put("3,6", 1); // 6,3 -> 3,6
  branchLimitPerNode.put("4,6", 1); // 6,4 -> 4,6
  branchLimitPerNode.put("5,6", 1); // 6,5 -> 5,6
  branchLimitPerNode.put("6,6", 1);

  branchLimitPerNode.put("0,7", 1); // 7,0 -> 0,7
  branchLimitPerNode.put("1,7", 0); // 7,1 -> 1,7
  branchLimitPerNode.put("2,7", 1); // 7,2 -> 2,7

  branchLimitPerNode.put("0,8", 2); // 8,0 -> 0,8

  branchLimitPerNode.put("0,9", 1); // 9,0 -> 0,9
  branchLimitPerNode.put("1,9", 0); // 9,1 -> 1,9

  branchLimitPerNode.put("0,10", 0); // 10,0 -> 0,10
}
