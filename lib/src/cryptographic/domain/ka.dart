import 'package:convert/convert.dart';
import 'package:great_wall/src/cryptographic/domain/node.dart';
import 'package:t3_formosa/formosa.dart';

/// The final seed resulting from the tacit derivation process, originating from the PA0 seed.
///
/// This class is responsible for deriving a BIP39 key (`seedBip39`) using an encoded hash
/// (`encodedHash`) as input and applying the derivation theme specified by `_formosa`.
class KA extends Node {
  final Formosa formosa;
  final String encodedHash;

  /// Initializes the `KA` instance with a [hash] and the specified [theme].
  /// 
  /// Automatically encodes [encodedHash] from [hash]during construction.
  KA(super.hash, super.depth, super.arity, {FormosaTheme theme = FormosaTheme.bip39})
      : formosa = Formosa(formosaTheme: theme, entropy: hash),
        encodedHash = hex.encode(hash);
}
