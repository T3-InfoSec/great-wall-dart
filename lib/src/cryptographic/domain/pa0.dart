import 'dart:math';
import 'dart:typed_data';

import 'package:t3_formosa/formosa.dart';

/// Pa0 represents the initial seed input into the derivation protocol.
/// From this seed, the protocol will derive SA0 and other critical components.
///
/// This seed is encrypted using an ephemeral key (Eka) for storage security.
class Pa0 {
  static const int wordsNumber = 6;

  final String seed;
  List<int> seedEncrypted;

  /// Constructs a [Pa0] instance.
  ///
  /// If no [seed] is provided, a six-words BIP39 seed will be generated automatically.
  Pa0({String? seed})
      : seed = seed ?? _generateSixWordsSeed(),
        seedEncrypted = [];

  /// Generates a six-words BIP39 seed using random entropy and bip39 as Formosa theme.
  static String _generateSixWordsSeed() {
    Uint8List entropy = generateRandomEntropy();
    return Formosa(
      formosaTheme: FormosaTheme.bip39, 
      entropy: entropy).seed;
  }

  static Uint8List generateRandomEntropy() {
    const int byteMaxValue = 256;
    const double bytesPerWord = 1.33;    
    final int entropyBytesForSeed = (wordsNumber * bytesPerWord).ceil();

    Uint8List randomEntropy = Uint8List(entropyBytesForSeed);
    Random random = Random.secure();
    for (int i = 0; i < randomEntropy.length; i++) {
      randomEntropy[i] = random.nextInt(byteMaxValue);
    }
    return randomEntropy;
  }
}
