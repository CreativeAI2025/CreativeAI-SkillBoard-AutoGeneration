HashMap<Integer, List<Integer>> graph = new HashMap<>();
ArrayList<Integer> startNodes = new ArrayList<>();//最上層のノードを記録
ArrayList<Integer> goalNodes = new ArrayList<>();//getDistYから最下層にあるノードを記録
ArrayList<ArrayList<Integer>> allPaths = new ArrayList<>();//原点ノードから目標ノードへの全ての経路を記録

//connectionsからIDの遷移を取得してグラフ構築、目的ノード、原点ノードの取得
void buildGraph() {
  // グラフ構築
  graph.clear();
  for (int[] pair : connections) {
    int from = pair[0];
    int to = pair[1];
    graph.putIfAbsent(from, new ArrayList<>());
    graph.get(from).add(to);
  }

  // 目的ノード、原点ノード取得
  startNodes.clear();
  goalNodes.clear();
  for (Node n : nodeData) {
    if (n.getDistY() == 0) startNodes.add(n.getId());
    if (n.getDistY() == rows - 1) goalNodes.add(n.getId());
  }
}

//深さ優先探索で原点から目的までの全ルートを走査
void dfs(int current, List<Integer> path, Set<Integer> visited) {
  if (visited.contains(current)) return; //探索済みは再訪しない
  visited.add(current); //訪れたことを記録
  path.add(current); //訪れたノードのIDを記録

  if (goalNodes.contains(current)) {
    allPaths.add(new ArrayList<>(path)); //目的ノードに到着したら、そこまでのpathをallpathに保存
  } else {
    for (int next : graph.getOrDefault(current, new ArrayList<>())) { //そうでない場合は再帰的に続ける
      dfs(next, path, visited);
    }
  }

  path.remove(path.size() - 1); //再帰前に状態を戻す
  visited.remove(current);
}

//dfs()で最短経路のみ探す
void findAllShortestPaths() {
  allPaths.clear();
  shortestPaths.clear(); //初期化

  for (int start : startNodes) {
    dfs(start, new ArrayList<>(), new HashSet<>());
  }

  // 最短長を取得
  int minLength = Integer.MAX_VALUE;
  for (ArrayList<Integer> path : allPaths) {
    minLength = min(minLength, path.size());
  }

  // 最短の経路のみ抽出
  for (ArrayList<Integer> path : allPaths) {
    if (path.size() == minLength) {
      shortestPaths.add(path);  // ← グローバル変数に追加
    }
  }

  // ↓↓↓ この部分もメソッド内に入れておくべき
  println("全最短経路の数：" + shortestPaths.size());
  for (ArrayList<Integer> p : shortestPaths) {
    println(p);
  }
}
