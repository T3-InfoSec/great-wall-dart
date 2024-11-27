import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/sa0.dart';
import 'package:great_wall/src/cryptographic/service/argon2_derivation_service.dart';

/// Sa1 represents a derived state from Sa0
class Sa1 {
  static final int bytesSize = 128;

  Uint8List _seed;

  /// Constructs an Sa1 instance with an initial [_seed] of [bytesSize]
  Sa1() : _seed = Uint8List(bytesSize);

  Uint8List get seed => _seed;

  /// Updates the value of [_seed] based on the seed from a given [sa0].
  void from(Sa0 sa0) {
    print('Deriving SA0 to SA1');
    _seed = Argon2DerivationService().deriveWithModerateMemory(sa0.seed);
  }

  @override
  String toString() => 'Sa1(seed: ${String.fromCharCodes(_seed)}';
}