// TODO: Complete the copyright.
// Copyright (c) 2024, ...

/// A path representation of a traversed nodes in a tree.
class DerivationPath<N extends int> extends Iterable<int> {
  final List<N> _nodesList;

  DerivationPath({
    List<N> nodesList = const [],
  }) : _nodesList = nodesList;

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

  /// Pop out the last node of the [DerivationPath].
  void pop() {
    _nodesList.removeAt(_nodesList.length - 1);
  }
}
