// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

/// A sealed and abstract class for tacit knowledge param implementation
sealed class TacitKnowledgeParam {
  static final Uint8List argon2Salt = Uint8List(32);
  static final int bytesCount = 4;

  final Uint8List state;
  final Map<String, Uint8List> adjustmentParams;

  TacitKnowledgeParam(this.state, this.adjustmentParams);

  /// Get the value that represents the param.
  Object? get value => _computeValue();

  /// Get a valid tacit knowledge value from provided adjustment params.
  ///
  /// jth candidate L_(i+1), the state resulting from appending bytes of j
  /// (here, branch_idx_bytes to current state L_i and hashing it)
  // TODO: Enhance the docs.
  Uint8List _computeValue() {
    Uint8List nextStateCandidate = state;
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: 3,
      parallelism: 1,
      memorySizeKB: 1024 * 1024,
      salt: argon2Salt,
    );

    adjustmentParams.forEach((param, tacitKnowledgeParamBytes) {
      nextStateCandidate = argon2Algorithm.convert(nextStateCandidate).bytes;
      nextStateCandidate =
          Uint8List.fromList(nextStateCandidate + tacitKnowledgeParamBytes);
    });

    return argon2Algorithm
        .convert(nextStateCandidate)
        .bytes
        .sublist(0, bytesCount);
  }
}

/// A representation of the fractal tacit knowledge param.
final class FractalTacitKnowledgeParam extends TacitKnowledgeParam {
  FractalTacitKnowledgeParam(super.state, super.adjustmentParams);

  @override
  num? get value {
    if (adjustmentParams.containsKey('real_p')) {
      return _computeRealParam(super._computeValue());
    } else if (adjustmentParams.containsKey('imag_p')) {
      return _computeImaginaryParam(super._computeValue());
    } else {
      return _computeRealParam(super._computeValue());
    }
  }

  double _computeRealParam(Uint8List param) {
    // NOTE: Inverting the order of digits to minimize Benford's law bias.
    String realParam = '2.${int.parse(param.reversed.join())}';
    return double.parse(realParam);
  }

  double _computeImaginaryParam(Uint8List param) {
    // NOTE: Inverting the order of digits to minimize Benford's law bias.
    String imaginaryParam = '0.${int.parse(param.reversed.join())}';
    return double.parse(imaginaryParam);
  }
}

/// A representation of the formosa tacit knowledge param.
final class FormosaTacitKnowledgeParam extends TacitKnowledgeParam {
  FormosaTacitKnowledgeParam(super.state, super.adjustmentParams);

  @override
  Uint8List? get value => _computeValue();
}

/// A sealed and abstract class for tacit knowledge implementation
sealed class TacitKnowledge {}

// Class for generating mnemonics (consider using an existing library)
final class Formosa implements TacitKnowledge {
  String expandPassword(String password) {
    // Implement password expansion logic
    return password;
  }

  String toMnemonic(String data) {
    // Implement logic to convert data to mnemonic
    return data;
  }

  // Add methods for other mnemonic functionalities
}

// Class for generating fractals (consider using an existing library)
final class Fractal implements TacitKnowledge {
  String funcType = "burningship";

  // Add methods for updating fractals based on parameters
}

// Class for generating mnemonics (consider using an existing library)
final class HashViz implements TacitKnowledge {
  String expandPassword(String password) {
    // Implement password expansion logic
    return password;
  }

  // Add methods for other mnemonic functionalities
}
