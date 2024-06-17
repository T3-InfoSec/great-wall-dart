// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'knowledges.dart';

// Argon2 parameters
enum Argon2Config { salt }

// Class representing derivation path
class DerivationPath {
  final List<int> _path;

  DerivationPath([List<int> path = const []]) : _path = List.unmodifiable(path);

  factory DerivationPath.from(Iterable<int> path) =>
      DerivationPath(path.toList());

  int get length => _path.length;

  int operator [](int index) => _path[index];

  /// Add [node] to the derivation path
  DerivationPath add(int node) => DerivationPath.from(_path..add(node));

  /// Clear all nodes from the derivation path.
  DerivationPath clear() => DerivationPath.from(_path..clear());
}

class TacitKnowledgeParam {
  // ... define properties and methods for FormosaTacitKnowledgeParam
}

class FormosaTacitKnowledgeParam extends TacitKnowledgeParam {
  // ... define properties and methods for FormosaTacitKnowledgeParam
}

class FractalTacitKnowledgeParam extends TacitKnowledgeParam {
  // ... define properties and methods for FractalTacitKnowledgeParam
}

// Class representing a memo card
class MemoCard {
  final List<String> knowledge;
  final KnowledgeType type;

  MemoCard(this.knowledge, this.type);
}
