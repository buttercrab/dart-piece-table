import 'package:piece_table/src/splay_tree.dart';

class PieceTable {
  /// Main database for piece table
  SplayTree<

      /// position in string of the piece
      /// - origin: (pos << 1) + 0
      /// - add:    (pos << 1) + 1
      /// Doing above we can reduce memory
      int> _tree;

  /// origin string for piece table
  String _origin;

  /// addition for piece table
  StringBuffer _add;

  /// Cursor position
  int _cursorPos;
  SplayTreeIterator _cursorIter;

  int get cursor => _cursorPos;

  PieceTable(this._origin) {
    _tree = SplayTree((a, b) => a < b);
    _add = StringBuffer();
    _cursorPos = 0;

    if (_origin.isNotEmpty) {
      _cursorIter = _tree.insert(0, _origin.length, 0);
    }
  }

  PieceTable.empty() : this('');

  void write(String s) {
    if (_cursorIter == null) {
      _cursorIter = _tree.insert((_add.length << 1) + 1, s.length, _cursorPos);
    } else {
      var weight = _cursorIter.weight;
      var value = _cursorIter.current;
      var pos = _tree.position(_cursorIter);
      var isAdd = value & 1;
      value >>= 1;

      if (pos + weight == _cursorPos) {
        if (isAdd && value + weight == _add.length) {
          _tree.erase(_cursorIter);
          _cursorIter = _tree.insert((value << 1) + 1, weight + s.length, pos);
        } else {
          _cursorIter =
              _tree.insert((_add.length << 1) + 1, s.length, _cursorPos);
        }
      } else if (pos == _cursorPos) {
        _cursorIter =
            _tree.insert((_add.length << 1) + 1, s.length, _cursorPos);
      } else {
        _tree.erase(_cursorIter);
        _tree.insert((value << 1) + isAdd, _cursorPos - pos, pos);
        _tree.insert((value << 1) + 1, weight - _cursorPos + pos,
            pos + _cursorPos - pos);
        _cursorIter =
            _tree.insert((_add.length << 1) + 1, s.length, _cursorPos);
      }
    }
    _cursorPos += s.length;
    _add.write(s);
  }
}
