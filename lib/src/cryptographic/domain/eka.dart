import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/pa0.dart';
import 'package:great_wall/src/cryptographic/service/encryption_service.dart';

/// Eka is an ephemeral encryption key used to encrypt critical data such as Pa0.
/// 
/// Eka acts as a last resort option for retrieving PA0 if the original entry seed is forgotten.
class Eka {
  static const int keyLength = 32; // Digits
  static const int hexBase = 16;
  static const int digitsChunkSize = 4;

  String key;

  Eka() : key = _generateHexadecimalKey();

  /// Generates a secure random hexadecimal key, formatted into [digitsChunkSize]-character blocks
  /// separated by spaces for readability.
  ///
  /// - Generates a [keyLength]-character hexadecimal sequence.
  /// - Formats the key into [digitsChunkSize]-character blocks separated by spaces using a regex.
  /// - Removes trailing spaces with `trim()`.
  static String _generateHexadecimalKey() {
    final random = Random.secure();
    final buffer = StringBuffer();

    for (int i = 0; i < keyLength; i++) {
      buffer.write(random.nextInt(hexBase).toRadixString(hexBase));
    }

    return buffer.toString().toUpperCase().replaceAllMapped(
      RegExp('.{$digitsChunkSize}'),
      (match) => "${match.group(0)} ",
    ).trim();
  }

  /// Encrypts the [pa0] instance using this Eka and stores the result
  /// in the `seedEncrypted` attribute of [pa0].
  ///
  /// This method requires that `generateHexadecimalKey` has been called previously,
  /// otherwise it will throw an exception.
  Future<void> encryptPa0(Pa0 pa0) async {
    if (key.isEmpty) {
      throw Exception("Eka key is not generated.");
    }

    Uint8List encode = utf8.encode(pa0.seed);
    pa0.seedEncrypted = await EncryptionService().encrypt(encode, key);
  }
}
