import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/critical.dart';
import 'package:t3_formosa/formosa.dart';

/// Sa0 represents the initial seed entered into the derivation protocol.
///
/// This seed is encrypted using a key for secure storage.
class Sa0 extends Critical {
  static final int bytesSize = 128;
  
  Formosa? formosa;

  /// Constructs an [Sa0] instance
  /// 
  /// with an initial [value] of [bytesSize]
  Sa0() : super(Uint8List(bytesSize));

  Sa0._(this.formosa) : super(Uint8List.fromList(formosa!.entropy));

  factory Sa0.fromFormosa({Formosa? providedFormosa}) {
    return Sa0._(providedFormosa ?? _generateSixWordsFormosa());
  }

  /// Generates a six-words BIP39 seed using random entropy and bip39 as Formosa theme.
  static Formosa _generateSixWordsFormosa() {
    Uint8List entropy = _generateRandomEntropy();
    return Formosa(
      formosaTheme: FormosaTheme.bip39, 
      entropy: entropy);
  }

  @override
  String toString() => 'Sa0(value: ${String.fromCharCodes(value)}';
}
