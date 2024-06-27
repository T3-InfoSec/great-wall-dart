// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'knowledge.dart';

// Class representing derivation path
class DerivationPath {
  final List<int> _path;

  DerivationPath([List<int> path = const []]) : _path = List.unmodifiable(path);

  factory DerivationPath.from(Iterable<int> path) =>
      DerivationPath(path.toList());

  int get length => _path.length;

  int operator [](int index) => _path[index];

  /// Add [node] to the end of this [DerivationPath], extending the
  /// length by one.
  DerivationPath add(int node) => DerivationPath.from(_path..add(node));

  /// Pop out the last node of the [DerivationPath].
  DerivationPath pop() =>
      DerivationPath.from(_path..removeAt(_path.length - 1));

  /// Removes all nodes from this [DerivationPath]; the length of the
  /// [DerivationPath] becomes zero.
  void clear() => DerivationPath.from(_path..clear());

  /// Whether the collection contains an element equal to [element].
  ///
  /// This operation will check each element in order for being equal to
  /// [element], unless it has a more efficient way to find an element
  /// equal to [element].
  bool contains(Object? element) => _path.contains(element);
}

// Class representing a memo card
class MemoCard {
  final List<String> knowledge;
  final KnowledgeType type;

  MemoCard(this.knowledge, this.type);
}
