// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:collection';

/// A path representation of a traversed nodes in a tree.
class DerivationPath extends ListBase<int> {
  final List<int> _pathList = [];

  DerivationPath();

  @override
  set length(int newLength) {
    _pathList.length = newLength;
  }

  @override
  int get length => _pathList.length;

  @override
  int operator [](int index) => _pathList[index];

  @override
  void operator []=(int index, int value) {
    _pathList[index] = value;
  }

  /// Pop out the last node of the [DerivationPath].
  void pop() {
    _pathList.removeAt(_pathList.length - 1);
  }
}
