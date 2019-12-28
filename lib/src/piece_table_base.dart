import 'package:piece_table/src/splay_tree.dart';

/// Piece Table
/// https://en.wikipedia.org/wiki/Piece_table
class PieceTable {
  /// Main database for piece table
  SplayTree<

      /// Position in string of the piece
      /// - origin: (pos << 1) + 0
      /// - add:    (pos << 1) + 1
      /// Doing above we can reduce memory
      int> _tree;

  /// Original string for piece table
  String _origin;

  /// Addition for piece table
  List<int> _add;

  /// Cursor position
  int _cursorPos;
  SplayTreeIterator _cursorIter;

  /// Cursor position getter
  int get cursor => _cursorPos;

  /// Length of string
  int _length;

  /// Length getter
  int get length => _length;

  /// Piece Table with original string
  PieceTable(this._origin) {
    _tree = SplayTree((a, b) => a < b);
    _add = [];
    _cursorPos = 0;
    _length = 0;

    if (_origin.isNotEmpty) {
      _cursorIter = _tree.insert(0, _origin.length, 0);
    }
  }

  /// Empty Piece table
  PieceTable.empty() : this('');

  /// Write string in cursor position
  /// Cursor will be moved by string length like normal text editor
  ///
  /// Time Complexity: amortized O(s.length + log(_tree.length))
  /// (amortized O(s.length) (array append operation) + amortized O(log(_tree.length)) (splay operation))
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
        if (isAdd == 1 && value + weight == _add.length) {
          _tree.updateNode(_cursorIter, weight: weight + s.length);
        } else {
          _cursorIter =
              _tree.insert((_add.length << 1) + 1, s.length, _cursorPos);
        }
      } else if (pos == _cursorPos) {
        _cursorIter =
            _tree.insert((_add.length << 1) + 1, s.length, _cursorPos);
      } else {
        _tree.updateNode(_cursorIter, weight: _cursorPos - pos);
        _tree.insert(((value + _cursorPos - pos) << 1) + isAdd,
            weight - _cursorPos + pos, pos + _cursorPos - pos);
        _cursorIter =
            _tree.insert((_add.length << 1) + 1, s.length, _cursorPos);
      }
    }
    _cursorPos += s.length;
    _length += s.length;

    for (var i = 0; i < s.length; i++) {
      _add.add(s.codeUnitAt(i));
    }
  }

  /// Erase one character in cursor position
  /// Cursor moves like normal text editor
  ///
  /// Time Complexity: amortized O(log(_tree.length)) (splay operation)
  void backspace() {
    if (_cursorIter == null || _cursorPos == 0) return;
    var weight = _cursorIter.weight;
    var value = _cursorIter.current;
    var pos = _tree.position(_cursorIter);
    var isAdd = value & 1;
    value >>= 1;

    if (pos + weight == _cursorPos) {
      _tree.updateNode(_cursorIter, weight: weight - 1);
    } else if (pos == _cursorPos) {
      _cursorIter.moveBack();
      _tree.updateNode(_cursorIter, weight: _cursorIter.weight - 1);
    } else {
      _tree.updateNode(_cursorIter, weight: _cursorPos - pos - 1);
      _tree.insert(
          ((value + _cursorPos - pos) << 1) + isAdd, weight, _cursorPos);
    }
    --_cursorPos;
    --_length;
  }

  /// Move cursor by n
  /// If it goes out of range, it would stay at the end or start
  ///
  /// Time Complexity: amortized O(log(_tree.length)) (splay operation)
  void moveCursor(int n) {
    _cursorPos += n;
    if (_cursorPos < 0) _cursorPos = 0;
    if (_cursorPos > _length) _cursorPos = _length;
    _cursorIter = _tree.lower_bound(_cursorPos);
  }

  /// Piece table to string
  ///
  /// Time Complexity: O(length)
  @override
  String toString() {
    var it = _tree.begin;
    var buffer = StringBuffer();

    do {
      var value = it.current;
      var weight = it.weight;
      var isAdd = value & 1;
      value >>= 1;

      for (var i = 0; i < weight; i++) {
        buffer.writeCharCode(isAdd == 1
            ? _add.elementAt(i + value)
            : _origin.codeUnitAt(i + value));
      }
    } while (it.moveNext());

    return buffer.toString();
  }
}
