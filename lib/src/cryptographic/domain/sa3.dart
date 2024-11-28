import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/sa0.dart';
import 'package:great_wall/src/cryptographic/domain/sa2.dart';
import 'package:great_wall/src/cryptographic/service/argon2_derivation_service.dart';

/// Sa3 represents a derived state from Sa2
class Sa3 {
  static final int bytesSize = 128;

  Uint8List _seed;

  /// Constructs an Sa3 instance with an initial [_seed] of [bytesSize]
  Sa3() : _seed = Uint8List(bytesSize);

  Uint8List get seed => _seed;

  /// Updates the value of [_seed] based on the seed from a given [sa2].
  void from(Sa0 sa0, Sa2 sa2) {
    print('Deriving SA2 to SA3');
    _seed = Argon2DerivationService()
        .deriveWithModerateMemory(Uint8List.fromList(sa0.seed + sa2.seed));
  }

  @override
  String toString() => 'Sa3(seed: ${String.fromCharCodes(_seed)}';
}
