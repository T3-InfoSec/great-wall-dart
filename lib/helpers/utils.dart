import 'package:argon2/argon2.dart';
import 'dart:convert';

class DerivationPath extends List<String> {
  /// A representation of the tree-like derivation key.

  DerivationPath copy() {
    /// Create a shallow copy of the path.
    return DerivationPath.from(this);
  }

  @override
  bool contains(Object? item) {
    return join(' -> ').contains(item.toString());
  }

  @override
  bool operator ==(Object other) {
    return join(' -> ') == other.toString();
  }

  @override
  int get hashCode {
    return join(' -> ').hashCode;
  }

  @override
  String toString() {
    if (length > 1) {
      return join(' -> ');
    } else if (length == 1) {
      return join('');
    } else {
      return '';
    }
  }
}

class TacitKnowledgeParam {
  /// A representation of the tacit knowledge params.

  static final List<int> ARGON2_SALT =
      utf8.encode("00000000000000000000000000000000");
  static const int NUM_BYTES_FORM = 4;

  final List<int> state;
  final Map<String, List<int>> adjustmentParams;
  List<int>? _value;

  TacitKnowledgeParam(this.state, this.adjustmentParams);

  List<int>? getValue() {
    /// Get the value of the param.
    _value = _computeValue();
    return _value;
  }

  List<int> _computeValue() {
    /// Get a valid tacit knowledge value from provided adjustment params.

    // jth candidate L_(i+1), the state resulting from appending bytes of j
    // (here, branch_idx_bytes to current state L_i and hashing it)
    List<int> nextStateCandidate = state;
    adjustmentParams.forEach((param, tacitKnowledgeParamBytes) {
      nextStateCandidate = argon2HashRaw(
        Argon2Parameters(
          argon2Type: Argon2Type.i,
          version: Argon2Version.V13,
          memoryPowerOf2: 10, // 1024 memory_cost
          parallelism: 1,
          iterations: 32,
          salt: ARGON2_SALT,
          hashLength: 128,
        ),
        nextStateCandidate + tacitKnowledgeParamBytes,
      );
    });

    return nextStateCandidate.sublist(0, NUM_BYTES_FORM);
  }
}

class FractalTacitKnowledgeParam extends TacitKnowledgeParam {
  /// A representation of the fractal tacit knowledge param.

  FractalTacitKnowledgeParam(
      List<int> state, Map<String, List<int>> adjustmentParams)
      : super(state, adjustmentParams);

  double _computeRealPValue(List<int> value) {
    // NOTE: We inverting the order of digits by operation [::-1] on string,
    // to minimize Benford's law bias.
    String realP = '2.' + int.parse(value.reversed.join()).toString();
    return double.parse(realP);
  }

  double _computeImagPValue(List<int> value) {
    // NOTE: We inverting the order of digits by operation [::-1] on string,
    // to minimize Benford's law bias.
    String imagP = '0.' + int.parse(value.reversed.join()).toString();
    return double.parse(imagP);
  }

  @override
  List<int> _computeValue() {
    if (adjustmentParams.containsKey('real_p')) {
      return _computeRealPValue(super._computeValue());
    } else if (adjustmentParams.containsKey('imag_p')) {
      return _computeImagPValue(super._computeValue());
    } else {
      return super._computeValue();
    }
  }
}

class FormosaTacitKnowledgeParam extends TacitKnowledgeParam {
  /// A representation of the formosa tacit knowledge param.

  FormosaTacitKnowledgeParam(
      List<int> state, Map<String, List<int>> adjustmentParams)
      : super(state, adjustmentParams);

  @override
  List<int> _computeValue() {
    return super._computeValue();
  }
}

class ShapeTacitKnowledgeParam extends TacitKnowledgeParam {
  /// A representation of the shape tacit knowledge param.

  ShapeTacitKnowledgeParam(
      List<int> state, Map<String, List<int>> adjustmentParams)
      : super(state, adjustmentParams);

  @override
  List<int> _computeValue() {
    return super._computeValue();
  }
}
