import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/pa0.dart';

/// Sa0 represents a derived state from Pa0
class Sa0 {
  static final int bytesSize = 128;

  Uint8List _seed;

  /// Constructs an Sa0 instance with an initial [_seed] of [bytesSize]
  Sa0() : _seed = Uint8List(bytesSize);

  Uint8List get seed => _seed;

  /// Updates the value of [seed] based on the seed from a given [pa0].
  void from(Pa0 pa0) {
    _seed = Uint8List.fromList(pa0.seed.codeUnits);
  }

  @override
  String toString() => 'Sa0(seed: ${String.fromCharCodes(_seed)}';
}