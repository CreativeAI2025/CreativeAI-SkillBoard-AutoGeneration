//int cols = 20;//行
//int rows = 20;//列
//int cellSize = 50;//1マスの大きさ

//PVector start = new PVector(0,0);//スタート位置
//PVector goal = new PVector(9, 9);   // ゴール位置（右下）

//boolean[][] visited = new boolean[cols][rows]; // 探索済みフラグ
//int[][] dist = new int[cols][rows];            // スタートからの距離を格納
//PVector[][] prev = new PVector[cols][rows];    // どこから来たか（経路用）

//ArrayList<PVector> queue = new ArrayList<PVector>();//探索用キューに位置を追加
////queue は探索順を管理するキューです（幅優先探索の肝）

//PVector[] directions = {//移動可能方向
//  new PVector(0, -1), new PVector(0, 1), // 上下
//  new PVector(-1, 0), new PVector(1, 0), // 左右
//  new PVector(-1, -1), new PVector(1, -1), // 左上・右上
//  new PVector(-1, 1), new PVector(1, 1)     // 左下・右下
//};


//void setup() {
//  fullScreen();//画面サイズ
//  reset();//配列の初期化
//  startPosBFS();//BFSのスタート地点登録
//  BFSSearch();//幅優先探索
//}

//void draw() {
//  background(255);

//  // 各マスの描画と距離の表示
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      int d = dist[x][y];
//      if (d >= 0) {
//        fill(map(d, 0, maxDist, 0, 255), 100, 200);
//      } else {
//        fill(0);//スタートの色
//      }
//      stroke(0);
//      rect(x * cellSize, y * cellSize, cellSize, cellSize);
//      if (d >= 0) {
//        fill(0);
//        textAlign(CENTER, CENTER);
//        text(d, x * cellSize + cellSize/2, y * cellSize + cellSize/2);
//      }
//    }
//  }
//  nodeSet();// ノード描画
//  drawLine();  // ノード間の線描画
//  noLoop();
//}

//public void reset() {//初期化
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      dist[x][y] = -1;//距離を -1 に初期化（未到達）
//      prev[x][y] = null;//こから来たかを記録するための配列
//    }
//  }
//}

//public void startPosBFS() {//BFS(幅優先探索)のスタート地点登録
//  queue.add(start);
//  visited[(int)start.x][(int)start.y] = true;
//  dist[(int)start.x][(int)start.y] = 0;
//}

//int maxDist = 0; // BFS後に最大距離を記録

//void BFSSearch() {//幅優先探索
//  while (!queue.isEmpty()) {
//    PVector current = queue.remove(0);//現在の位置
//    for (PVector dir : directions) {
//      int nx = (int)(current.x + dir.x);
//      int ny = (int)(current.y + dir.y);

//      if (nx >= 0 && nx < cols && ny >= 0 && ny < rows && !visited[nx][ny]) {//範囲内 && 未訪問
//        visited[nx][ny] = true;
//        dist[nx][ny] = dist[(int)current.x][(int)current.y] + 1;
//        prev[nx][ny] = current.copy();  // どこから来たか記録
//        queue.add(new PVector(nx, ny));

//        // 最大距離を更新
//        if (dist[nx][ny] > maxDist) {
//          maxDist = dist[nx][ny];
//        }
//      }
//    }
//  }
//}

//boolean nodechack[][] = new boolean[cols][rows];//ノードがあるかの確認

//void nodeSet() {//ノードを配置(ノードがない距離があった場合もう一回生成を行うことをするべき)
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      if (dist[x][y] <= 0) {
//        fill(255, 255, 0);
//        ellipse(x * cellSize + cellSize/2, y * cellSize  + cellSize/2, cellSize / 2, cellSize / 2);
//        nodechack[x][y] = true;
//      } else if (dist[x][y] < cols / 3) {
//        if (randomInt(-5, 2) < 0) {
//          fill(255);
//          ellipse(x * cellSize + cellSize/2, y * cellSize  + cellSize/2, cellSize / 2, cellSize / 2);
//          nodechack[x][y] = true;
//        }
//      }
//    }
//  }
//}

//void drawLine() {
//  class Node {
//    int gridX, gridY;
//    PVector pos;
//    int dist;

//    Node(int gridX, int gridY, PVector pos, int dist) {
//      this.gridX = gridX;
//      this.gridY = gridY;
//      this.pos = pos;
//      this.dist = dist;
//    }
//  }

//  ArrayList<Node> nodes = new ArrayList<Node>();

//  // ノードの位置と情報を収集
//  for (int x = 0; x < cols; x++) {
//    for (int y = 0; y < rows; y++) {
//      if (nodechack[x][y]) {
//        PVector center = new PVector(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2);
//        nodes.add(new Node(x, y, center, dist[x][y]));
//      }
//    }
//  }

//  // 線を描く
//  stroke(255, 0, 0, 180); // 赤い半透明の線
//  strokeWeight(2);

//  for (int i = 0; i < nodes.size(); i++) {
//    Node a = nodes.get(i);
//    for (int j = i + 1; j < nodes.size(); j++) {
//      Node b = nodes.get(j);

//      // 探索距離がちょうど1差で、かつ物理距離が近いノード同士だけ結ぶ
//      if (abs(a.dist - b.dist) == 1 && dist(a.pos.x, a.pos.y, b.pos.x, b.pos.y) <= cellSize * 1.5) {
//        line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
//      }
//    }
//  }
//}
