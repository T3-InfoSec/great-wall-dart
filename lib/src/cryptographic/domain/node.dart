import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/sa0.dart';

/// Node represents a derived state of the protocol derivation process.
class Node {
  Uint8List _currentHash;

  /// Constructs a Node instance with an initial [_currentHash] from [sa0]
  Node(Sa0 sa0) : _currentHash = sa0.seed; // TODO: review node initialization from sa3.

  /// Updates the value of [_currentHash] based on given [currentHash].
  void update(Uint8List currentHash) {
    _currentHash = currentHash;
  }

  Uint8List get currentHash => _currentHash;

  @override
  String toString() => 'Node(currentHash: ${String.fromCharCodes(_currentHash)}';
}