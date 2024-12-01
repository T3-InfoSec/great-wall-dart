import 'dart:math';

/// Eka is an ephemeral encryption key used to encrypt critical data.
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
}
