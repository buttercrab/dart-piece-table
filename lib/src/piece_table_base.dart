import 'package:piece_table/src/splay_tree.dart';
import 'package:tuple/tuple.dart';

class PieceTable {
  /// item1: start pos
  /// item2: length
  SplayTree<Tuple2<int, int>, int> _tree;

  PieceTable() {
    _tree = SplayTree((a, b) => a.item1 < b.item1, (a, b, _) => a.item1 + b);
  }
}
