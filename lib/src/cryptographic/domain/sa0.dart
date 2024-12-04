import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/critical.dart';
import 'package:t3_formosa/formosa.dart';

/// Sa0 represents the initial entropy entered into the derivation protocol.
///
/// This seed is Critical so it has to be encrypted using a key for secure storage.
class Sa0 extends Critical {
  static final int bytesSize = 128;

  Formosa formosa;

  /// Constructs an [Sa0] instance
  ///
  /// with an initial [value] of [bytesSize]
  Sa0({Uint8List? entropy})
      : formosa = Formosa(
            formosaTheme: FormosaTheme.bip39,
            entropy: entropy ?? Uint8List(bytesSize)),
        super(entropy ?? Uint8List(bytesSize));

  factory Sa0.fromRandomEntropy() {
    return Sa0(entropy: Formosa.generateRandomEntropy(wordsNumber: 6));
  }

  Sa0._(this.formosa) : super(Uint8List.fromList(formosa.entropy));

  factory Sa0.fromFormosa(Formosa providedFormosa) {
    return Sa0._(providedFormosa);
  }

  factory Sa0.fromMnemonic(String mnemonic) {
    return Sa0._(Formosa.fromMnemonic(
      formosaTheme: FormosaTheme.bip39, 
      mnemonic: mnemonic));
  }

  @override
  String toString() => 'Sa0(value: ${String.fromCharCodes(value)}';
}
