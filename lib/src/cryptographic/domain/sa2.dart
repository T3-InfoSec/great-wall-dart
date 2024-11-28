import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/sa1.dart';
import 'package:great_wall/src/cryptographic/service/argon2_derivation_service.dart';

/// Sa2 represents a derived state from Sa1
class Sa2 {
  static final int bytesSize = 128;

  Uint8List _seed;

  /// Constructs an Sa2 instance with an initial [_seed] of [bytesSize]
  Sa2() : _seed = Uint8List(bytesSize);

  Uint8List get seed => _seed;

  /// Updates the value of [_seed] based on the seed from a given [sa1].
  /// 
  /// The derivation process is repeated [iterations] times, where each iteration
  /// derives the seed using a memory-intensive key derivation algorithm. 
  void from(int iterations, Sa1 sa1) {
    print('Deriving SA1 to SA2');
    _seed = Argon2DerivationService().deriveWithHighMemory(iterations, sa1.seed);
  }

  @override
  String toString() => 'Sa2(seed: ${String.fromCharCodes(_seed)}';
}