import 'package:convert/convert.dart';
import 'package:great_wall/src/cryptographic/domain/node.dart';
import 'package:t3_formosa/formosa.dart';

/// The final node in the tacit derivation process, derived from the PA0 seed.
///
/// Represents the final derived state that generates the secret key, derived into 
/// [formosa] and encoded in hexadecimal [hexadecimalValue]
class KA extends Node {
  final Formosa formosa;
  final String hexadecimalValue;

  /// Initializes the [KA] node instance with an entropy [value] and the specified formosa [theme].
  /// 
  /// Automatically encodes [hexadecimalValue] from [value] during construction.
  KA(super.value, {FormosaTheme theme = FormosaTheme.bip39})
      : formosa = Formosa(formosaTheme: theme, entropy: value),
        hexadecimalValue = hex.encode(value);
}
