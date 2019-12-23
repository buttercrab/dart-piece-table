import 'dart:math';

import 'package:piece_table/src/splay_tree.dart';
import 'package:test/test.dart';

// from https://stackoverflow.com/a/13556240
List shuffle(List items) {
  var random = Random();

  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

void main() {
  test('insert test', () {
    var n = 10000;

    var tree = SplayTree<int, int>((a, b) => a < b, (a, b, c) => (b ?? 0) + 1);

    var a = <int>[];
    for (var i = 0; i < n; i++) {
      a.add(i);
    }

    a = shuffle(a);

    for (var i in a) {
      tree.insert(i);
    }

    var it = tree.begin;

    var ans = <int>[];
    do {
      ans.add(it.current.item1);
    } while (it.moveNext());

    expect([for (var i = 0; i < n; i++) i], equals(ans));
  });

  test('delete test', () {
    var n = 10000;

    var tree = SplayTree<int, int>((a, b) => a < b, (a, b, c) => (b ?? 0) + 1);

    var a = <int>[];
    for (var i = 0; i < n; i++) {
      a.add(i);
    }

    a = shuffle(a);

    for (var i in a) {
      tree.insert(i);
    }

    for (var i = 0; i < n ~/ 2; i++) {
      tree.erase(tree.find(a[i]));
    }

    var it = tree.begin;
    var ans = <int>[];

    do {
      ans.add(it.current.item1);
    } while (it.moveNext());

    a = a.sublist(n ~/ 2, n);
    a.sort((a, b) => a.compareTo(b));
    expect(a, equals(ans));
  });
}
