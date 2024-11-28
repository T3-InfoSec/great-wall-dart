import 'dart:convert';
import 'dart:math';

import 'package:great_wall/src/cryptographic/service/encryption_service.dart';

import 'package:test/test.dart';

void main() {
  final encryptionService = EncryptionService();

  group('EncryptionService Tests', () {
    const key = "temporaryEphemeralKey";
    const plainText = "This is a test string";
    final plainTextBytes = utf8.encode(plainText);

    test('encryptPA0 should encrypt plainText with AES-GCM and produce concatenated data', () async {
      final encryptedData = await encryptionService.encrypt(plainTextBytes, key);

      expect(encryptedData, isNotNull);
      expect(encryptedData.length, greaterThan(12 + 16));
    });

    test('should decrypt encrypted data back to original plainText', () async {
      final encryptedData = await encryptionService.encrypt(plainTextBytes, key);

      final decryptedData = await encryptionService.decrypt(encryptedData, key);
      String decodedData = utf8.decode(decryptedData);

      expect(decodedData, plainText);
    });

    test('encrypt should produce unique nonces for each encryption', () async {
      final List<List<int>> previousNonces = [];
      const int testIterations = 10000;

      for (int i = 0; i < testIterations; i++) {
        final pa0 = List.generate(16, (_) => Random().nextInt(256)).join();
        final pa0Bytes = utf8.encode(pa0);
        final encryptedData = await encryptionService.encrypt(pa0Bytes, key);

        final nonce = encryptedData.sublist(0, 12);

        final isDuplicate = previousNonces.any((prevNonce) => listEquals(prevNonce, nonce));
        expect(isDuplicate, isFalse, reason: 'Nonce repetition detected.');

        previousNonces.add(nonce);
      }
    }, timeout: const Timeout(Duration(seconds: 60)), skip: true);
  });
}

listEquals(List<int> prevNonce, List<int> nonce) {
}
