HashMap<Integer, Skill> skillAssignment = new HashMap<>();
HashMap<Integer, Status> statusAssignment = new HashMap<>();
ArrayList<ArrayList<Integer>> shortestPaths = new ArrayList<>();
HashSet<Integer> assignedNodes = new HashSet<>();
HashMap<Integer, Float> nodeScoreMap = new HashMap<>();

void SkillSetter() {
  assignedNodes.clear();
  nodeScoreMap.clear();

  //スキルの割り当て
  for (Node node : nodeData) {
    int nodeId = node.getId();
    int distY = node.getDistY();
    float minScore = getMinScoreForLayer(distY);
    float maxScore = getMaxScoreForLayer(distY);

//前のノードより高いscoreのスキルを選出
    float prevScore = -1.0f; 
    if (graph.containsKey(nodeId)) {
      for (int parent : graph.get(nodeId)) {
        prevScore = max(prevScore, nodeScoreMap.getOrDefault(parent, -1.0f));
      }
    }

    if (assignedNodes.contains(nodeId)) continue;

    boolean assigned = false;
    Iterator<Skill> iter = skillList.iterator();
    while (iter.hasNext()) {
      Skill s = iter.next();
      if (s.score >= minScore && s.score <= maxScore && s.score >= prevScore) {
        assignSkillToNode(s, nodeId);
        nodeScoreMap.put(nodeId, s.score);
        assignedNodes.add(nodeId);
        iter.remove();
        assigned = true;
        break;
      }
    }

    //前のスキルより高いscoreのスキルが無い場合、scoreが同値のスキルを選出
    if (!assigned) {
      iter = skillList.iterator();
      while (iter.hasNext()) {
        Skill s = iter.next();
        if (s.score == prevScore && s.score >= minScore && s.score <= maxScore) {
          assignSkillToNode(s, nodeId);
          nodeScoreMap.put(nodeId, s.score);
          assignedNodes.add(nodeId);
          iter.remove();
          println("ノード " + nodeId + " にスキル [" + s.name + "] (score: " + s.score + ") を割り当て（同値）");
          assigned = true;
          break;
        }
      }
    }

   
    //割り当てられなかった場合のログ
    if (!assignedNodes.contains(nodeId)) {
      println("⚠ ノード " + nodeId + " に割り当て可能なスキル・ステータスがありません");
    }
  }
}

// スキル割り当て関数
void assignSkillToNode(Skill s, int nodeId) {
  Node node = nodeData.get(nodeId);
  node.skill_name = s.name;
  node.skill_type = s.type;
  node.skill_category = s.category;
  node.skill_effect = s.effect;
  node.skill_score = s.score;
  println("ノード " + nodeId + " にスキル [" + s.name + "] (score: " + s.score + ") を割り当て");
}

// ステータス割り当て関数
//void assignStatusToNode(Status st, int nodeId) {
  //Node node = nodeData.get(nodeId);
  //node.skill_name = st.name;
  //node.skill_type = "Status";
  //node.skill_category = "";
  //node.skill_effect = "";
  //node.skill_score = 0.0f;  // ステータスにscoreは不要なら0に
//}

// 層ごとの最小スコア
float getMinScoreForLayer(int distY) {
  if (distY <= 3) return 0.0f;
  else if (distY <= 6) return 0.0f;
  else return 0.7f;
}

// 層ごとの最大スコア
float getMaxScoreForLayer(int distY) {
  if (distY <= 3) return 0.3f;
  else if (distY <= 6) return 0.6f;
  else return 1.0f;
}
