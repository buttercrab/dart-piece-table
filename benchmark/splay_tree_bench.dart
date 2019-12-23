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
    for (var i = 0; i < 1000; i++) {
      tree.insert(random.nextInt(1000000000));
    }
  }

  @override
  void setup() {
    tree = SplayTree<int, int>((a, b) => a < b, (a, b, c) => (b ?? 0) + 1);
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
    for (var i = 0; i < 1000; i++) {
      tree.insert(random.nextInt(1000000000));
    }

    for (var i = 0; i < 1000; i++) {
      var it = tree.lower_bound(random.nextInt(1000000000));
      if (it.current.item1 == null) it = tree.begin;
      tree.erase(it);
    }
  }

  @override
  void setup() {
    tree = SplayTree<int, int>((a, b) => a < b, (a, b, c) => (b ?? 0) + 1);
    random = Random(328239);
  }

  @override
  void teardown() {
    tree = null;
  }
}

void main() {
  SplayInsertBenchmark.main();
  SplayEraseBenchmark.main();
}
