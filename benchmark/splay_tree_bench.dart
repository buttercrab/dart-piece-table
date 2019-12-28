import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:piece_table/src/splay_tree.dart';

SplayTree tree;
Random random;

class SplayInsertBenchmark extends BenchmarkBase {
  const SplayInsertBenchmark() : super('Template');

  static void main() {
    SplayInsertBenchmark().report();
  }

  @override
  void run() {
    tree.insert(random.nextInt(1000000000), 1, random.nextInt(tree.length + 1));
  }

  @override
  void setup() {
    tree = SplayTree<int>((a, b) => a < b);
    random = Random(328239);
  }

  @override
  void teardown() {
    tree = null;
  }
}

class SplayEraseBenchmark extends BenchmarkBase {
  const SplayEraseBenchmark() : super('Template');

  static void main() {
    SplayEraseBenchmark().report();
  }

  @override
  void run() {
    tree.insert(random.nextInt(1000000000), 1, random.nextInt(tree.length + 1));

    var it = tree.lower_bound(random.nextInt(tree.length + 1));
    if (it.current == null) it = tree.begin;
    tree.erase(it);
  }

  @override
  void setup() {
    tree = SplayTree<int>((a, b) => a < b);
    random = Random(328239);

    for (var i = 0; i < 1000000; i++) {
      tree.insert(
          random.nextInt(1000000000), 1, random.nextInt(tree.length + 1));
    }
  }

  @override
  void teardown() {
    tree = null;
  }
}

void main() {
  for (var i = 1; i <= 5; i++) {
    print('Test $i');
    print('  Splay Tree insert test:');
    SplayInsertBenchmark.main();
    print('  Splay Tree insert & erase test:');
    SplayEraseBenchmark.main();
  }
}
