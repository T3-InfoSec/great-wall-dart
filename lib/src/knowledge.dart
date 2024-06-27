// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
// import 'package:formosa/formosa.dart';
// import 'package:fractal/fractal.dart';
// import 'package:hashviz/hashviz.dart';

/// A sealed and abstract class for tacit knowledge param implementation
sealed class TacitKnowledgeParam {
  static final Uint8List argon2Salt = Uint8List(32);
  static final int bytesCount = 4;

  final String name;
  final Uint8List initialState;
  final Uint8List adjustmentValue;

  TacitKnowledgeParam(this.name, this.initialState, this.adjustmentValue);

  /// Get the value that represents the param.
  void get value;

  /// Get a valid tacit knowledge value from provided adjustment params.
  ///
  /// jth candidate L_(i+1), the state resulting from appending bytes of j
  /// (here, branch_idx_bytes to current state L_i and hashing it)
  // TODO: Enhance the docs.
  Uint8List _computeValue() {
    Uint8List nextStateCandidate = initialState;
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: 3,
      parallelism: 1,
      memorySizeKB: 1024 * 1024,
      salt: argon2Salt,
    );

    nextStateCandidate = Uint8List.fromList(
      argon2Algorithm.convert(nextStateCandidate).bytes + adjustmentValue,
    );

    return argon2Algorithm
        .convert(nextStateCandidate)
        .bytes
        .sublist(0, bytesCount);
  }
}

/// A representation of the fractal tacit knowledge param.
final class FractalTacitKnowledgeParam extends TacitKnowledgeParam {
  FractalTacitKnowledgeParam(
    super.name,
    super.initialState,
    super.adjustmentValue,
  );

  @override
  num get value {
    if (super.name == 'realParam') {
      return _computeRealParam(super._computeValue());
    } else if (super.name == 'imaginaryParam') {
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
  FormosaTacitKnowledgeParam(
    super.name,
    super.initialState,
    super.adjustmentValue,
  );

  @override
  Uint8List get value => super._computeValue();
}

/// A sealed and abstract class for tacit knowledge implementation
sealed class TacitKnowledge {
  Object _knowledgeGenerator;
  Map<String, Object> configs;
  Map<String, TacitKnowledgeParam> params;

  TacitKnowledge(this._knowledgeGenerator, this.configs, this.params);

  void get knowledge;
}

// Class for generating mnemonics (consider using an existing library)
final class FormosaTacitKnowledge extends TacitKnowledge {
  FormosaTacitKnowledge._internal(
    super._knowledgeGenerator,
    super.configs,
    super.params,
  );

  factory FormosaTacitKnowledge(
    Map<String, Object> configs,
    Map<String, TacitKnowledgeParam> params,
  ) {
    Formosa knowledgeGenerator = Formosa(theme: 'BiP39');

    return FormosaTacitKnowledge._internal(
      knowledgeGenerator,
      configs,
      params,
    );
  }

  /// Returns a mnemonic string.
  ///
  /// Returns the mnemonic string that represents the actual tacit knowledge
  /// of the [FormosaTacitKnowledge] tacit knowledge. Throws on [Exception]
  /// if the [TacitKnowledge.configs] or [TacitKnowledge.params] or both
  /// are empty because this will generate an insecure [TacitKnowledge].
  @override
  String get knowledge {
    if (configs.isEmpty || params.isEmpty) {
      throw Exception(
        'The configs or params or both are empty which is insecure arguments.'
        ' Please, to get a correct and secure tacit knowledge provides'
        ' the TacitKnowledge implementation with the correct arguments.',
      );
    }

    _knowledgeGenerator = Formosa(configs['theme']);
    var knowledge = _knowledgeGenerator.toMnemonic(
      formosaParam: params['formosaParam']!.value,
    );

    return knowledge;
  }
}

// Class for generating fractals (consider using an existing library)
final class FractalTacitKnowledge extends TacitKnowledge {
  FractalTacitKnowledge._internal(
    super._knowledgeGenerator,
    super.configs,
    super.params,
  );

  factory FractalTacitKnowledge(
    Map<String, Object> configs,
    Map<String, FractalTacitKnowledgeParam> params,
  ) {
    if (configs.isEmpty || params.isEmpty) {
      throw Exception('Empty Maps of configs or params or both.');
    }

    Fractal knowledgeGenerator = Fractal(
      configs['fractalSet'],
      configs['colorScheme'],
    );

    return FractalTacitKnowledge._internal(
      knowledgeGenerator,
      configs,
      params,
    );
  }

  /// Returns a 1D or 3D fractal image.
  ///
  /// Returns the image that represents the actual tacit knowledge of the
  /// [FractalTacitKnowledge] tacit knowledge. Throws on [Exception]
  /// if the [TacitKnowledge.configs] or [TacitKnowledge.params] or both
  /// are empty because this will generate an insecure [TacitKnowledge].
  @override
  String get knowledge {
    if (configs.isEmpty || params.isEmpty) {
      throw Exception(
        'The configs or params or both are empty which is insecure arguments.'
        ' Please, to get a correct and secure tacit knowledge provides'
        ' the TacitKnowledge implementation with the correct arguments.',
      );
    }

    _knowledgeGenerator.imagePixels = _knowledgeGenerator.update(
      fractalSet: configs['fractalSet'],
      colorScheme: configs['colorScheme'],
      xMin: configs['xMin'],
      xMax: configs['xMax'],
      yMin: configs['yMin'],
      yMax: configs['yMax'],
      realParam: params['realParam']?.value,
      imaginaryParam: params['imaginaryParam']?.value,
      width: configs['width'],
      height: configs['height'],
      escapeRadius: configs['escapeRadius'],
      maxIteration: configs['maxIteration'],
    );

    return _knowledgeGenerator.imagePixels;
  }
}

// TODO: Implement Hashviz tacit knowledge.
/// Class for generating hashviz (consider using an existing library)
// final class HashVizTacitKnowledge extends TacitKnowledge {
//   HashVizTacitKnowledge._internal(
//     super._knowledgeGenerator,
//     super.configs,
//     super.initState,
//   );
//
//   factory HashVizTacitKnowledge(
//     Map<String, Object> configs,
//     Map<String, HashVizTacitKnowledgeParam> params,
//   ) {
//     // TODO: implement the logic.
//     HashViz knowledgeGenerator = HashViz(configs['size']);
//
//     return HashVizTacitKnowledge._internal(
//       knowledgeGenerator,
//       configs,
//       params,
//     );
//   }
//
//   /// Returns a 3D visualization image of the hash.
//   ///
//   /// Returns image that represents the actual tacit knowledge of the
//   /// [HashVizTacitKnowledge] tacit knowledge.
//   @override
//   List<dynamic> get knowledge {
//
//   }
// }
