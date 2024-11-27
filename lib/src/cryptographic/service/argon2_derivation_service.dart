import 'dart:typed_data';
import 'package:hashlib/hashlib.dart';

/// A service for performing hash derivation using the Argon2 algorithm.
///
/// This class provides methods to derive cryptographic hashes with different 
/// memory configurations using the Argon2i variant of the Argon2 algorithm.
class Argon2DerivationService {

  final Uint8List argon2Salt = Uint8List(32);

  /// Derives a cryptographic hash using Argon2 with high memory usage given an [inputHash].
  ///
  /// To achieve a presumably high execution time, this method should be called 
  /// multiple times. It is designed for scenarios where stronger computational 
  /// resistance is required by increasing the cumulative processing time.
  Uint8List deriveWithHighMemory(Uint8List inputHash) {
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128, // Bytes
      iterations: 1,
      parallelism: 1,
      memorySizeKB: 1024 * 1024, // 1 GB
      salt: argon2Salt,
    );
      
    return argon2Algorithm.convert(inputHash).bytes;
  }

  /// Derives a cryptographic hash using Argon2 with moderate memory usage given an [inputHash].
  ///
  /// This derivation is designed to require presumably little time, depending 
  /// on the specifications of the device running the process. It is suitable 
  /// for scenarios where a quick derivation process is desirable.
  Uint8List deriveWithModerateMemory(Uint8List inputHash) {
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128, // Bytes
      iterations: 1,
      parallelism: 1,
      memorySizeKB: 10 * 1024, // 10 MB
      salt: argon2Salt,
    );

    return argon2Algorithm.convert(inputHash).bytes;
  }
}
