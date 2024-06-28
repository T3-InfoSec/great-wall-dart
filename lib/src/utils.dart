// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:collection';

/// A path representation of a traversed nodes in a tree.
class DerivationPath<E extends int> extends ListBase<E> {
  final List<E> _nodesList;

  DerivationPath({
    List<E> nodesList = const [],
  }) : _nodesList = nodesList;

  @override
  set length(int newLength) {
    _nodesList.length = newLength;
  }

  @override
  int get length => _nodesList.length;

  @override
  E operator [](int index) => _nodesList[index];

  @override
  void operator []=(int index, E value) {
    _nodesList[index] = value;
  }

  @override
  void add(E element) {
    _nodesList.add(element);
  }

  /// Pop out the last node of the [DerivationPath].
  void pop() {
    _nodesList.removeAt(_nodesList.length - 1);
  }
}
