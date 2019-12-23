import 'package:tuple/tuple.dart';

/// node value type T
/// update value type U
class _SplayTreeNode<T, U> {
  T value;
  U update;
  _SplayTreeNode<T, U> parent, left, right;

  _SplayTreeNode.empty();

  _SplayTreeNode(this.value, [this.update, this.parent, this.left, this.right]);
}

/// node value type T
/// update value type U
class SplayTreeIterator<T, U> extends Iterator<Tuple2<T, U>> {
  _SplayTreeNode<T, U> _current;

  SplayTreeIterator(this._current);

  @override
  bool moveNext() {
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

  @override
  Tuple2<T, U> get current => Tuple2(_current?.value, _current?.update);
}

typedef CompareFunc<T> = bool Function(T a, T b);
typedef UpdateFunc<T, U> = U Function(T a, U b, U c);

/// node value type T
/// update value type U
class SplayTree<T, U> {
  final CompareFunc<T> _compareFunc;
  final UpdateFunc<T, U> _updateFunc;
  int _len;

  int get len => _len;
  _SplayTreeNode<T, U> _root;

  SplayTree(this._compareFunc, this._updateFunc) {
    _len = 0;
  }

  /// update the `update` value
  /// `n` can be null
  void _updateNode(_SplayTreeNode<T, U> n) {
    n?.update = _updateFunc(n?.value, n?.left?.update, n?.right?.update);
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
  void _leftRotation(_SplayTreeNode<T, U> n) {
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
  void _rightRotation(_SplayTreeNode<T, U> n) {
    var a = n.left,
        b = a.right,
        p = n.parent;
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
  void _splay(_SplayTreeNode<T, U> n) {
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

  /// Swap two nodes
  /// swapping values is better than
  /// swapping each parents & children
  void _swap(_SplayTreeNode<T, U> a, _SplayTreeNode<T, U> b) {
    var t = a.value;
    a.value = b.value;
    b.value = t;

    _updateNode(a);
    _updateNode(b);
  }

  _SplayTreeNode<T, U> _minimum(_SplayTreeNode<T, U> n) {
    while (n?.left != null) {
      n = n.left;
    }
    return n;
  }

  _SplayTreeNode<T, U> _maximum(_SplayTreeNode<T, U> n) {
    while (n?.right != null) {
      n = n.right;
    }
    return n;
  }

  _SplayTreeNode<T, U> _lowerBound(T value) {
    if (_len == 0) return null;
    var n = _root;
    var r;
    while (true) {
      if (_compareFunc(value, n.value)) {
        if (n.left == null) break;
        n = n.left;
      } else {
        r = n;
        if (n.right == null) break;
        n = n.right;
      }
    }
    return r;
  }

  _SplayTreeNode<T, U> _upperBound(T value) {
    if (_len == 0) return null;
    var n = _root;
    var r;
    while (true) {
      if (_compareFunc(n.value, value)) {
        r = n;
        if (n.right == null) break;
        n = n.right;
      } else {
        if (n.left == null) break;
        n = n.left;
      }
    }
    return r;
  }

  _SplayTreeNode<T, U> _find(T value) {
    if (_len == 0) return null;
    var n = _root;
    while (n != null) {
      if (n.value == value) {
        _splay(n);
        return n;
      }
      if (_compareFunc(value, n.value)) {
        n = n.left;
      } else {
        n = n.right;
      }
    }
    return n;
  }

  SplayTreeIterator<T, U> insert(T value) {
    if (_len == 0) {
      _len = 1;
      _root = _SplayTreeNode<T, U>(value);
      _updateNode(_root);
      return SplayTreeIterator<T, U>(_root);
    }
    var n = _root;
    var a = _SplayTreeNode<T, U>(value);
    while (true) {
      if (_compareFunc(value, n.value)) {
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
        n = n.right;
      }
    }
    a.parent = n;
    for (var i = a; i != null; i = i.parent) {
      _updateNode(i);
    }
    _splay(a);
    _len++;

    return SplayTreeIterator<T, U>(a);
  }

  void erase(SplayTreeIterator<T, U> iterator) {
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
    if (t != null) {
      _swap(n, t);
    } else {
      t = n;
    }

    var p = t.parent;
    var a = t.left ?? t.right;
    p?.left == t ? p?.left = a : p?.right = a;
    a?.parent = p;
    t.parent = null;
    t.left = null;
    t.right = null;

    for (var i = p; i != null; i = i.parent) {
      _updateNode(i);
    }
    _len--;
  }

  SplayTreeIterator<T, U> lower_bound(T value) {
    return SplayTreeIterator<T, U>(_lowerBound(value));
  }

  SplayTreeIterator<T, U> upper_bound(T value) {
    return SplayTreeIterator<T, U>(_upperBound(value));
  }

  SplayTreeIterator<T, U> find(T value) {
    return SplayTreeIterator<T, U>(_find(value));
  }

  SplayTreeIterator<T, U> get begin => SplayTreeIterator<T, U>(_minimum(_root));

  SplayTreeIterator<T, U> get end => SplayTreeIterator<T, U>(null);

  SplayTreeIterator<T, U> get front => begin;

  SplayTreeIterator<T, U> get back => SplayTreeIterator<T, U>(_maximum(_root));
}
