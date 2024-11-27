import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class EncryptionService {

  /// Encrypts a list of bytes [plainTextBytes] using AES-GCM with a derived ephemeral key from [key].
  ///
  /// This method securely encrypts the byte data [plainTextBytes] by first
  /// deriving a 256-bit AES encryption key from the provided string [key] using a 
  /// key derivation function. The [AesGcm.with256bits()] algorithm is employed 
  /// for encryption, ensuring both confidentiality and authenticity of the 
  /// resulting encrypted data.
  ///
  /// The encryption process returns a `List<int>` containing the concatenated result
  /// of the `SecretBox`, which includes the ciphertext, a nonce (randomly generated 
  /// for each encryption operation), and a MAC (Message Authentication Code) that 
  /// protects the integrity and authenticity of the encrypted data.
  Future<List<int>> encrypt(List<int> plainTextBytes, String key) async {
    final derivedKey = await deriveKey(key);
    final algorithm = AesGcm.with256bits();

    final secretBox = await algorithm.encrypt(
      plainTextBytes,
      secretKey: derivedKey,
      // default randomness unique nonce (aka initialization vector, or "salt") https://pub.dev/documentation/cryptography/latest/cryptography/Cipher/encrypt.html
    );
    return secretBox.concatenation();
  }

  /// Decrypts an encrypted byte list [cipherText] using AES-GCM with the derived ephemeral key from [key].
  ///
  /// The [cipherText] parameter should be a single `List<int>` containing a concatenation
  /// of the nonce, ciphertext, and MAC (Message Authentication Code). This structure allows
  /// for easy storage and transmission, ensuring all necessary components for decryption are present.
  ///
  /// This method extracts the `nonce` from the first 12 bytes of [cipherText] (AES-GCM requires a
  /// unique nonce per encryption for security), and retrieves the `ciphertext` and `MAC` 
  /// from the remaining bytes. It then creates a `SecretBox` object with these components, 
  /// which the AES-GCM algorithm uses for decryption. Finally, the method decrypts 
  /// the data and returns the original byte list.
  Future<List<int>> decrypt(List<int> cipherText, String key) async {
    final derivedKey = await deriveKey(key);
    final algorithm = AesGcm.with256bits();
    final nonce = cipherText.sublist(0, 12);
    final ciphertextWithMac = cipherText.sublist(12);

    final secretBox = SecretBox(
      ciphertextWithMac.sublist(0, ciphertextWithMac.length - 16),
      nonce: nonce,
      mac: Mac(ciphertextWithMac.sublist(ciphertextWithMac.length - 16)),
    );

    final decryptedBytes = await algorithm.decrypt(
      secretBox,
      secretKey: derivedKey,
    );
    return decryptedBytes;
  }

  /// Derives a 256-bit AES encryption key from the provided [key] string using the Argon2id algorithm.
  ///
  /// This method is designed to generate a secure key suitable for AES-GCM encryption by applying
  /// the Argon2id key derivation function on the input [key].
  Future<SecretKey> deriveKey(String key) async {
    final argon2 = Argon2id(
      parallelism: 4,
      iterations: 3,
      memory: 65536, // KB (64 MB),
      hashLength: 32, // 256 bits
    );

    final secretKey = await argon2.deriveKey(
      secretKey: SecretKey(utf8.encode(key)),
      nonce: [],
    );

    return secretKey;
  }
}
