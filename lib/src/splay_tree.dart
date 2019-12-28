/// node value type T
class _SplayTreeNode<T> {
  T value;
  int count, weight;
  _SplayTreeNode<T> parent, left, right;

  _SplayTreeNode.empty();

  _SplayTreeNode(this.value, this.weight, [this.parent, this.left, this.right]);
}

/// node value type T
class SplayTreeIterator<T> extends Iterator<T> {
  _SplayTreeNode<T> _current;

  SplayTreeIterator(this._current);

  @override
  bool moveNext() {
    if (_current == null) return false;
    if (_current.right != null) {
      _current = _current.right;
      while (_current.left != null) {
        _current = _current.left;
      }
      return true;
    }
    while (_current.parent?.right == _current) {
      _current = _current.parent;
    }
    _current = _current.parent;
    return _current != null;
  }

  bool moveBack() {
    if (_current == null) return false;
    if (_current.left != null) {
      _current = _current.left;
      while (_current.right != null) {
        _current = _current.right;
      }
      return true;
    }
    while (_current.parent?.left == _current) {
      _current = _current.parent;
    }
    _current = _current.parent;
    return _current != null;
  }

  @override
  T get current => _current?.value;

  set current(T value) {
    _current?.value = value;
  }

  int get weight => _current?.weight;

  int get count => _current?.count;
}

typedef CompareFunc = bool Function(int a, int b);

/// node value type T
/// update value type U
///
/// Custom Splay Tree for Piece Table
/// It can be used as normal
/// @see splay_tree_test.dart
class SplayTree<T> {
  final CompareFunc _compareFunc;

  int _len;

  int get len => _len;
  _SplayTreeNode<T> _root;

  SplayTree(this._compareFunc) {
    _len = 0;
  }

  /// update the `update` value
  /// `n` can be null
  void _updateNode(_SplayTreeNode<T> n) {
    n?.count =
        (n?.left?.count ?? 0) + (n?.right?.count ?? 0) + (n?.weight ?? 0);
  }

  /// Left Rotation
  ///
  ///   p            p
  ///   |            |
  ///   n            a
  ///  / \    =>    / \
  /// x   a        n   y
  ///    / \      / \
  ///   b   y    x   b
  ///
  /// Assertion: `a` is not null
  void _leftRotation(_SplayTreeNode<T> n) {
    var a = n.right, b = a.left, p = n.parent;
    n.right = b;
    a.left = n;
    p?.left == n ? p?.left = a : p?.right = a;
    a.parent = p;
    n.parent = a;
    b?.parent = n;

    _updateNode(a);
    _updateNode(n);
  }

  /// Right Rotation
  ///
  ///     p        p
  ///     |        |
  ///     n        a
  ///    / \  =>  / \
  ///   a   y    x   n
  ///  / \          / \
  /// x   b        b   y
  ///
  /// Assertion: `a` is not null
  void _rightRotation(_SplayTreeNode<T> n) {
    var a = n.left, b = a.right, p = n.parent;
    n.left = b;
    a.right = n;
    p?.left == n ? p?.left = a : p?.right = a;
    a.parent = p;
    n.parent = a;
    b?.parent = n;

    _updateNode(a);
    _updateNode(n);
  }

  /// Splay operation
  /// It makes the node to the root
  ///
  /// 1. Zig step
  ///
  ///     p        n     |   p            n
  ///    / \      / \    |  / \          / \
  ///   n   C => A   p   | A   n   =>   p   C
  ///  / \          / \  |    / \      / \
  /// A   B        B   C |   B   C    A   B
  ///
  ///
  /// 2. Zig-zig step
  ///
  ///       q        n       |   q                n
  ///      / \      / \      |  / \              / \
  ///     p   D    A   p     | A   p            p   D
  ///    / \    =>    / \    |    / \    =>    / \
  ///   n   C        B   q   |   B   n        q   C
  ///  / \              / \  |      / \      / \
  /// A   B            C   D |     C   D    A   B
  ///
  ///
  /// 3. Zig-zag step
  ///
  ///     q                    |   q
  ///    / \           n       |  / \             n
  ///   p   D        /   \     | A   p          /   \
  ///  / \    =>   p       q   |    / \  =>   q       p
  /// A   n       / \     / \  |   n   D     / \     / \
  ///    / \     A   B   C   D |  / \       A   B   C   D
  ///   B   C                  | B   C
  ///
  void _splay(_SplayTreeNode<T> n) {
    while (n.parent != null) {
      if (n.parent.parent == null) {
        // Zig step
        n.parent.left == n ? _rightRotation(n.parent) : _leftRotation(n.parent);
      } else if (n.parent.left == n && n.parent.parent.left == n.parent) {
        // Zig-zig step (left)
        _rightRotation(n.parent.parent);
        _rightRotation(n.parent);
      } else if (n.parent.right == n && n.parent.parent.right == n.parent) {
        // Zig-zig step (right)
        _leftRotation(n.parent.parent);
        _leftRotation(n.parent);
      } else if (n.parent.right == n) {
        // Zig-zag step (left)
        _leftRotation(n.parent);
        _rightRotation(n.parent);
      } else {
        // Zig-zag step (right)
        _rightRotation(n.parent);
        _leftRotation(n.parent);
      }
    }
    _root = n;
  }

  _SplayTreeNode<T> _minimum(_SplayTreeNode<T> n) {
    while (n?.left != null) {
      n = n.left;
    }
    return n;
  }

  _SplayTreeNode<T> _maximum(_SplayTreeNode<T> n) {
    while (n?.right != null) {
      n = n.right;
    }
    return n;
  }

  /// max node that `node <= value`
  _SplayTreeNode<T> _lowerBound(int value) {
    if (_len == 0) return null;
    var n = _root;
    var r;
    while (true) {
      if (_compareFunc(value, n.left?.count ?? 0)) {
        if (n.left == null) break;
        n = n.left;
      } else {
        r = n;
        if (n.right == null) break;
        value -= (n.left?.count ?? 0) + n.count;
        n = n.right;
      }
    }
    return r;
  }

  /// min node that `node >= value`
  _SplayTreeNode<T> _upperBound(int value) {
    if (_len == 0) return null;
    var n = _root;
    var r;
    while (true) {
      if (_compareFunc(n.left?.count ?? 0, value)) {
        r = n;
        if (n.right == null) break;
        value -= (n.left?.count ?? 0) + n.count;
        n = n.right;
      } else {
        if (n.left == null) break;
        n = n.left;
      }
    }
    return r;
  }

  /// finds the value
  /// if not returns null
  _SplayTreeNode<T> _find(int value) {
    if (_len == 0) return null;
    var n = _root;
    while (n != null) {
      if (n.count == value) {
        _splay(n);
        return n;
      }
      if (_compareFunc(value, n.left?.count ?? 0)) {
        n = n.left;
      } else {
        value -= (n.left?.count ?? 0) + n.count;
        n = n.right;
      }
    }
    return n;
  }

  /// This Splay tree finds the location to insert
  /// by position of tree (not comparing elements)
  SplayTreeIterator<T> insert(T value, int weight, int position) {
    if (_len == 0) {
      _len = 1;
      _root = _SplayTreeNode<T>(value, weight);
      _updateNode(_root);
      return SplayTreeIterator<T>(_root);
    }
    var n = _root;
    var a = _SplayTreeNode<T>(value, weight);
    while (true) {
      if (_compareFunc(position, n.left?.count ?? 0)) {
        if (n.left == null) {
          n.left = a;
          break;
        }
        n = n.left;
      } else {
        if (n.right == null) {
          n.right = a;
          break;
        }
        position -= (n.left?.count ?? 0) + n.count;
        n = n.right;
      }
    }
    a.parent = n;
    for (var i = a; i != null; i = i.parent) {
      _updateNode(i);
    }
    _splay(a);
    _len++;

    return SplayTreeIterator<T>(a);
  }

  void erase(SplayTreeIterator<T> iterator) {
    if (_len == 0) throw 'remove called when size is 0';
    if (iterator?._current == null) throw 'removing null';
    if (_len == 1) {
      _len = 0;
      _root = null;
      return;
    }
    var n = iterator._current;
    _splay(n);
    var t = _minimum(n.right);
    if (t == null) {
      _root = n.left;
      _root.parent = null;
      n.left = null;
      _len--;
      return;
    }

    n.value = t.value;

    var p = t.parent;
    p?.left == t ? p?.left = t.right : p?.right = t.right;
    t.right?.parent = p;
    t.parent = null;
    t.right = null;

    for (var i = p; i != null; i = i.parent) {
      _updateNode(i);
    }
    _len--;
  }

  void updateNode(SplayTreeIterator<T> iterator, {T value, int weight}) {
    if (iterator?._current == null) throw 'updating null';
    if (value == null && weight == null) throw 'new values are null';
    var n = iterator._current;
    if (value != null) {
      n.value = value;
    }
    if (weight != null) {
      _splay(n);
      n.weight = weight;
      _updateNode(n);
    }
  }

  int position(SplayTreeIterator<T> iterator) {
    if (iterator?._current == null) throw 'removing null';
    var n = iterator._current;
    _splay(n);
    return n.left?.count ?? 0;
  }

  SplayTreeIterator<T> lower_bound(int value) {
    return SplayTreeIterator<T>(_lowerBound(value));
  }

  SplayTreeIterator<T> upper_bound(int value) {
    return SplayTreeIterator<T>(_upperBound(value));
  }

  SplayTreeIterator<T> find(int value) {
    return SplayTreeIterator<T>(_find(value));
  }

  SplayTreeIterator<T> get begin => SplayTreeIterator<T>(_minimum(_root));

  SplayTreeIterator<T> get end => SplayTreeIterator<T>(null);

  SplayTreeIterator<T> get front => begin;

  SplayTreeIterator<T> get back => SplayTreeIterator<T>(_maximum(_root));
}
