ArrayList<Node> nodeData = new ArrayList<>();//ノードデータの保存

int getMoveNumber(int movenum) {//移動した番号を受け取り、確率に基づいて次の移動可能番号を決める関数
  float[] probs = nodePerData.getOrDefault(movenum, new float[]{0.0});// その場所に出現する確率を入れる
  float r = random(1);//0~0.9999..までの乱数
  float sum = 0;//確率の和
  for (int i = 0; i < probs.length; i++) {
    sum += probs[i];
    if (r < sum) return i;//移動先番号を返す
  }
  return probs.length - 1;//移動先番号を返す
}

int[] getMoveDist(int movenum) {

  int dist[] = {0, 0};

  switch(movenum) {
  case 0:
    dist[0] = 1;
    dist[1] = 0;
    return dist;
  case 1:
    dist[0] = 0;
    dist[1] = 1;
    return dist;
  case 2:
    dist[0] = -1;
    dist[1] = 1;
    return dist;
  case 3:
    dist[0] = -1;
    dist[1] = 0;
    return dist;
  case 4:
    dist[0] = 0;
    dist[1] = -1;
    return dist;
  case 5:
    dist[0] = 1;
    dist[1] = -1;
    return dist;
  }
  return dist;
}

void SkillStatusCount() {
  skillsum = 0;
  statussum = 0;
  for (int i = 0; i < skillData.size(); i++) {
    skillsum++;
  }

  statussum = (skillsum * 2)/3;//スキル・ステータスの統計的比率により算出
  //println(skillsum, statussum);
}

void NodeDataSet() {
  float start_x = 0.5;
  int id = 0;

  int distX = 0;
  int distY = 0;
  float drawPosX = 0;
  float drawPosY = 0;
  int nownum = 0;
  int beforenum = 0;

  SkillStatusCount();

  //for (int y = 0; y < 4; y++) {//実座標
  //  for (float x = start_x; x < 4 + start_x; x++) {
  //    drawPosY = y * cellSize * 1.5 + cellSize / 2 + height / 2.5;
  //    drawPosX = x * cellSize * 1.5  + width / 2.5;
  //    nodeData.add(new Node(id, (int)(x - start_x), y, drawPosX, drawPosY));
  //    id++;
  //  }
  //  start_x += 0.5;
  //}

  while (nodeData.size() < skillsum + statussum) {
    int i = nodeData.size(); // 現在追加するID
    int dist[] = new int[2];

    if (i == 0) {
      nodeData.add(new Node(i, distX, distY, startPosX, startPosY));
    } else {
      boolean validPos = false;
      int maxRetry = 100;
      int retry = 0;

      while (!validPos && retry < maxRetry) {
        retry++;

        if (i - 1 == 0) {
          beforenum = 6; // 初期状態
        }

        nownum = getMoveNumber(beforenum);
        dist = getMoveDist(nownum);
        beforenum = nownum;

        // 🔑 最新ノードを基準に計算
        Node prev = nodeData.get(nodeData.size() - 1);
        distX = prev.getDistX() + dist[0];
        distY = prev.getDistY() + dist[1];

        // 🎯 重複チェック
        validPos = true;
        for (Node n : nodeData) {
          if (n.getDistX() == distX && n.getDistY() == distY) {
            validPos = false;
            break;
          }
        }
      }

      if (validPos) {
        drawPosX = startPosX + distX * cellSize;
        drawPosY = startPosY + distY * cellSize;

        drawPosX += distY * cellSize * start_x;

        nodeData.add(new Node(i, distX, distY, drawPosX, drawPosY));
      } else {
        println("配置可能位置が見つかりませんでした: id=" + i);
        break; // 配置不可能ならループ終了するなど対応
      }
    }
  }
}
