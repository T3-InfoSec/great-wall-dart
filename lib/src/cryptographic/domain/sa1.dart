import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/entropy.dart';
import 'package:great_wall/src/cryptographic/domain/sa0.dart';
import 'package:great_wall/src/cryptographic/service/argon2_derivation_service.dart';

/// Represents the first derived state [Sa1] in the protocol derivation process.
/// 
/// It is derived from the initial entropy state [Sa0]
class Sa1 extends Entropy{
  static final int bytesSize = 128;

  /// Constructs an instance of [Sa1] with an initial entropy [value]
  /// of [bytesSize] bytes.
  /// 
  /// The initial entropy is initialized as an empty byte array of the specified size.
  Sa1() : super(Uint8List(bytesSize));

  /// Derives the entropy [value] from the given initial entropy [sa0].
  /// 
  /// This method updates the [value] of the current instance by applying
  /// a derivation process using the seed from [sa0].
  void from(Sa0 sa0) {
    print('Deriving SA0 to SA1');
    value = Argon2DerivationService().deriveWithModerateMemory(sa0.seed);
  }

  @override
  String toString() => 'Sa1(seed: ${String.fromCharCodes(value)}';
}
