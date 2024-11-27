import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/node.dart';
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

  Eka({String? key}) : key = key ?? _generateHexadecimalKey();

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

  /// Encrypts the [pa0] sedd using this Eka and stores the result
  /// in the seedEncrypted attribute of [pa0]
  Future<void> encryptPa0(Pa0 pa0) async {
    Uint8List encode = utf8.encode(pa0.seed);
    pa0.seedEncrypted = await EncryptionService().encrypt(encode, key);
  }

  /// Encrypts the [node] currentHash using this Eka and stores the result
  /// in the `hashEncrypted` attribute of [node].
  ///
  /// This method requires that `generateHexadecimalKey` has been called previously,
  /// otherwise it will throw an exception.
  Future<void> encryptNode(Node node) async {
    node.hashEncrypted = await EncryptionService().encrypt(node.hash, key);
  }

  /// Decrypts the given base64 [seedEncrypted] string and returns a [Pa0] object.
  ///
  /// This method decrypts the provided string using Eka and returns the decrypted data as a Pa0 instance.
  Future<Pa0> decryptToPa0(String seedEncrypted) async {
    Uint8List decodedBytes = base64Decode(seedEncrypted);
    List<int> decryptedBytes = await EncryptionService().decrypt(decodedBytes, key);
    String seed = utf8.decode(decryptedBytes);
    return Pa0(seed: seed);
  }

  /// Decrypts the given base64 [hashEncrypted] string and returns a [Node] object.
  ///
  /// This method decrypts the provided string using Eka and returns the decrypted data as a Node instance.
  Future<Node> decryptToNode(String hashEncrypted) async {
    Uint8List decodedBytes = base64Decode(hashEncrypted);
    List<int> decryptedBytes = await EncryptionService().decrypt(decodedBytes, key);
    return Node(Uint8List.fromList(decryptedBytes));
  }
}
