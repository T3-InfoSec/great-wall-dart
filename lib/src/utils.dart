// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:typed_data';

import 'package:t3_crypto_objects/crypto_objects.dart';

/// A path representation of a traversed nodes in a tree.
class DerivationPath<N extends Uint8List> extends Iterable<N> { // we will have binary data instead of int


  final List<N> _nodesList;

  DerivationPath({
    List<N>? nodesList,
  }) : _nodesList = (nodesList == null) ? [] : nodesList;

  @override
  int get hashCode => Object.hashAll(_nodesList);

  @override
  Iterator<N> get iterator => _nodesList.iterator;

  @override
  int get length => _nodesList.length;

  /// The number of nodes in this [DerivationPath].
  ///
  /// The valid indices for a [DerivationPath] are 0 through length - 1.
  set length(int newLength) {
    _nodesList.length = newLength;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DerivationPath &&
              runtimeType == other.runtimeType &&
              _listsAreEqual(_nodesList, other._nodesList as List<N>);



  bool _listsAreEqual(List<N> a, List<N> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  N operator [](int index) => _nodesList[index];

  void operator []=(int index, N node) {
    _nodesList[index] = node;
  }

  /// Adds [node] to the end of [DerivationPath].
  void add(N node) {
    _nodesList.add(node);
  }

  /// Removes all nodes from [DerivationPath]; the length of the
  /// [DerivationPath] becomes zero.
  void clear() {
    _nodesList.clear();
  }

  /// Returns a copy of this [DerivationPath].
  DerivationPath copy() {
    return DerivationPath(nodesList: _nodesList.toList(growable: true));
  }

  /// Pop out the last node of the [DerivationPath].
  void pop() {
    if (_nodesList.isNotEmpty) {
      _nodesList.removeLast();
    } else {
      return;
    }
  }
}
