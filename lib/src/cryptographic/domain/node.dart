import 'dart:typed_data';

/// Node represents a derived state of the protocol derivation process.
class Node {
  Uint8List currentHash;
  List<int> hashEncrypted;


  /// Constructs a Node instance with an initial [currentHash] from [hash]
  Node(Uint8List hash) :
  currentHash = hash,
  hashEncrypted = [];

  /// Updates the value of [currentHash] based on given [hash].
  void update(Uint8List hash) {
    currentHash = currentHash;
  }

  @override
  String toString() => 'Node(currentHash: ${String.fromCharCodes(currentHash)}';
}