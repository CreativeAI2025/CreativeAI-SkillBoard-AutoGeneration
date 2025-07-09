ArrayList<Node> tagData = new ArrayList<>();//ノードがスキル又はステータスなのかの保存
int skillCount = 0;
int statusCount = 0;

void TagSet() {//すきる・ステータスの振り分け
  HashSet<Integer> usedid = new HashSet<>();
  for (int[] pair : connections) {
    int from = pair[0];
    int to = pair[1];

    if (from == 0 && !usedid.contains(to)) {
      tagData.add(new Node(to, tagName("初期状態")));
    }

    if (!usedid.contains(to)) {
      tagData.add(new Node(to, tagName(tagData.get(from).getTag())));
    }
    usedid.add(to);
  }

  Comparator<Node> compare = Comparator.comparing(Node::getId);
  tagData.sort(compare);//昇順ソート
  println("タグセット");
  SScount(tagData);
}

String tagName(String tag) {//前の状態を受け取り、確率に基づいて次の状態を決める関数
  int tagNum = 0;//タグ番号
  float[] probs = skill_or_statusPerRow.getOrDefault(tag, new float[]{0.0});
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和

  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) {
      tagNum = i;//タグ番号を保持
      break;
    }
  }

  if (r >= sum) tagNum = probs.length - 1;

  //println(r,sum,tagNum);

  if (tagNum == 0) {
    return "スキル";
  } else if (tagNum == 1) {
    return "ステータス";
  }
  return null;
}

void SScount(ArrayList<Node> tagData) {
  skillCount = 0;
  statusCount = 0;

  for (Node t : tagData) {
    if (t.getTag() == "スキル") {
      skillCount++;
    }else{
      statusCount++;
    }
  }
}
