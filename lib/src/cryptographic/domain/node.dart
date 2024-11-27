import 'dart:typed_data';

/// Node represents a derived state of the protocol derivation process.
class Node {
  Uint8List hash;
  List<int> hashEncrypted;

  /// Constructs a Node instance with an initial [hash]
  Node(this.hash)
      : hashEncrypted = [];

  @override
  String toString() => 'Node(currentHash: ${String.fromCharCodes(hash)}';
}
