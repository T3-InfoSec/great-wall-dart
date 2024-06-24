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

  final Uint8List state;
  final Map<String, Uint8List> adjustmentParams;

  TacitKnowledgeParam(this.state, this.adjustmentParams);

  /// Get the value that represents the param.
  void get value;

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
  num get value {
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
  Uint8List get value => super._computeValue();
}

/// A sealed and abstract class for tacit knowledge implementation
sealed class TacitKnowledge {
  final Object knowledgeGenerator;
  Map<String, Object> configs;
  Map<String, TacitKnowledgeParam> params;

  TacitKnowledge(this.knowledgeGenerator, this.configs, this.params);

  void get knowledge;

  void updateConfigs(Map<String, Object> configs);

  void updateParams(covariant Map<String, TacitKnowledgeParam> params);
}

// Class for generating mnemonics (consider using an existing library)
final class FormosaTacitKnowledge extends TacitKnowledge {
  FormosaTacitKnowledge._internal(
    super.knowledgeGenerator,
    super.configs,
    super.params,
  );

  factory FormosaTacitKnowledge(
    Map<String, Object> configs,
    Map<String, TacitKnowledgeParam> params,
  ) {
    // TODO: implement the logic.
    Formosa knowledgeGenerator = Formosa(configs["theme"]);

    return FormosaTacitKnowledge._internal(
      knowledgeGenerator,
      configs,
      params,
    );
  }

  /// Returns a mnemonic string.
  ///
  /// This returned mnemonic string represents the actual tacit knowledge of
  //// the [FormosaTacitKnowledge] tacit knowledge.
  @override
  String get knowledge => knowledgeGenerator.toMnemonic();

  /// Update the configs of the tacit knowledge generator.
  @override
  void updateConfigs(Map<String, Object> configs) {}

  /// Update the params of the tacit knowledge generator.
  @override
  void updateParams(Map<String, FormosaTacitKnowledgeParam> params) {}
}

// Class for generating fractals (consider using an existing library)
final class FractalTacitKnowledge extends TacitKnowledge {
  FractalTacitKnowledge._internal(
    super.knowledgeGenerator,
    super.configs,
    super.params,
  );

  factory FractalTacitKnowledge(
    Map<String, Object> configs,
    Map<String, FractalTacitKnowledgeParam> params,
  ) {
    // TODO: implement the logic.
    Fractal knowledgeGenerator = Fractal(
      configs["fractalSet"],
      configs["colorScheme"],
    );

    return FractalTacitKnowledge._internal(
      knowledgeGenerator,
      configs,
      params,
    );
  }

  /// Returns a 1D or 3D fractal image.
  ///
  /// This returned image represents the actual tacit knowledge of the
  /// [FractalTacitKnowledge] tacit knowledge.
  @override
  List<dynamic> get knowledge => knowledgeGenerator.imagePixels;

  /// Update the configs of the tacit knowledge generator.
  @override
  void updateConfigs(Map<String, Object> configs) {
    knowledgeGenerator.imagePixels = knowledgeGenerator.update(
      fractalSet: configs["fractalSet"],
      colorScheme: configs["colorScheme"],
      xMin: configs["xMin"],
      xMax: configs["xMax"],
      yMin: configs["yMin"],
      yMax: configs["yMax"],
      width: configs["width"],
      height: configs["height"],
      escapeRadius: configs["escapeRadius"],
      maxIteration: configs["maxIteration"],
    );
  }

  /// Update the params of the tacit knowledge generator.
  @override
  void updateParams(Map<String, FractalTacitKnowledgeParam> params) {
    knowledgeGenerator.imagePixels = knowledgeGenerator.update(
      real_p: params["real_p"]?.value,
      imaginary_p: params["imaginary_p"]?.value,
    );
  }
}

// TODO: Implement Hashviz tacit knowledge.
/// Class for generating hashviz (consider using an existing library)
// final class HashVizTacitKnowledge extends TacitKnowledge {
//   HashVizTacitKnowledge._internal(
//     super.knowledgeGenerator,
//     super.configs,
//     super.initState,
//   );
//
//   factory HashVizTacitKnowledge(
//     Map<String, Object> configs,
//     Map<String, HashVizTacitKnowledgeParam> params,
//   ) {
//     // TODO: implement the logic.
//     HashViz knowledgeGenerator = HashViz(configs["size"]);
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
//   /// This returned image represents the actual tacit knowledge of the
//   /// [HashVizTacitKnowledge] tacit knowledge.
//   @override
//   List<dynamic> get knowledge => knowledgeGenerator.imagePixels;
//
//   /// Update the configs of the tacit knowledge generator.
//   @override
//   void updateConfigs(Map<String, Object> configs) {}
//
//   /// Update the params of the tacit knowledge generator.
//   @override
//   void updateParams(Map<String, HashVizTacitKnowledgeParam> params) {}
// }
