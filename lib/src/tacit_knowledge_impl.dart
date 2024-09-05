// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashviz/hashviz.dart';
import 'package:t3_formosa/formosa.dart';

import 'tacit_knowledge_types.dart';
// import 'package:fractal/fractal.dart';

/// A sealed and abstract class for tacit knowledge param implementation
class TacitKnowledgeParam {
  static final Uint8List argon2Salt = Uint8List(32);
  static final int bytesCount = 4;

  final String name;
  final Uint8List initialState;
  final Uint8List adjustmentValue;

  TacitKnowledgeParam(this.name, this.initialState, this.adjustmentValue);

  /// Get the value that represents the param.
  Uint8List get value => _computeValue();

  /// Get a valid tacit knowledge value from provided adjustment params.
  ///
  /// jth candidate L_(i+1), the state resulting from appending bytes of j
  /// (here, branch_idx_bytes to current state L_i and hashing it)
  // TODO: Enhance the docs.
  Uint8List _computeValue() {
    Argon2 argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: 3,
      parallelism: 1,
      memorySizeKB: 1024 * 1024,
      salt: argon2Salt,
    );

    Uint8List nextStateCandidate = Uint8List.fromList(
      argon2Algorithm.convert(initialState).bytes + adjustmentValue,
    );

    return argon2Algorithm
        .convert(nextStateCandidate)
        .bytes
        .sublist(0, bytesCount);
  }
}

/// A sealed and abstract class for tacit knowledge implementation
sealed class TacitKnowledge {
  late Map<String, dynamic> configs;
  late TacitKnowledgeParam param;

  Object get knowledge;
}

/// A simple to use API for formosa tacit knowledge.
final class FormosaTacitKnowledge implements TacitKnowledge {
  Formosa _knowledgeGenerator;
  @override
  late Map<String, dynamic> configs;
  @override
  late TacitKnowledgeParam param;

  FormosaTacitKnowledge(
    this.configs,
    this.param,
  ) : _knowledgeGenerator = Formosa(
          formosaTheme: configs['formosaTheme'] ?? FormosaTheme.bip39,
        );

  /// Returns a mnemonic string.
  ///
  /// Returns the mnemonic string that represents the actual tacit knowledge
  /// of the [FormosaTacitKnowledge] tacit knowledge. Throws on [Exception]
  /// if the [TacitKnowledge.configs] or [TacitKnowledge.param] or both
  /// are empty because this will generate an insecure [TacitKnowledge].
  @override
  String get knowledge {
    if (configs.isEmpty) {
      throw Exception(
        'The configs param is empty which is insecure argument. Please,'
        ' to get a correct and secure tacit knowledge, provide the'
        ' TacitKnowledge implementation with the correct configs argument.',
      );
    }

    _knowledgeGenerator = Formosa(formosaTheme: configs['formosaTheme']!);
    String knowledge = _knowledgeGenerator.toFormosa(param.value);

    return knowledge;
  }
}

/// A simple to use API for fractal tacit knowledge.
// final class FractalTacitKnowledge implements TacitKnowledge {
//   Fractal _knowledgeGenerator;
//   @override
//   late Map<String, dynamic> configs;
//   @override
//   late TacitKnowledgeParam param;
//
//   FractalTacitKnowledge(
//     this.configs,
//     this.param,
//   ) : _knowledgeGenerator = Fractal(
//           fractalSet: configs['fractalSet']!,
//           colorScheme: configs['colorScheme']!,
//         );
//
//   /// Returns a 1D or 3D fractal image.
//   ///
//   /// Returns the image that represents the actual tacit knowledge of the
//   /// [FractalTacitKnowledge] tacit knowledge. Throws on [Exception]
//   /// if the [TacitKnowledge.configs] or [TacitKnowledge.param] or both
//   /// are empty because this will generate an insecure [TacitKnowledge].
//   @override
//   List<dynamic> get knowledge {
//     if (configs.isEmpty) {
//       throw Exception(
//         'The configs param is empty which is insecure argument. Please,'
//         ' to get a correct and secure tacit knowledge, provide the'
//         ' TacitKnowledge implementation with the correct configs argument.',
//       );
//     }
//
//     // NOTE: Inverting the order of digits to minimize Benford's law bias.
//     String realParam = '2.${int.parse(param.value.reversed.join())}';
//     String imaginaryParam = '0.${int.parse(param.value.reversed.join())}';
//     Map<String, double> params = {
//       'realParam': double.parse(realParam),
//       'imaginaryParam': double.parse(imaginaryParam)
//     };
//
//     _knowledgeGenerator.imagePixels = _knowledgeGenerator.update(
//       fractalSet: configs['fractalSet'],
//       colorScheme: configs['colorScheme'],
//       xMin: configs['xMin'],
//       xMax: configs['xMax'],
//       yMin: configs['yMin'],
//       yMax: configs['yMax'],
//       realParam: params['realParam'],
//       imaginaryParam: params['imaginaryParam'],
//       width: configs['width'],
//       height: configs['height'],
//       escapeRadius: configs['escapeRadius'],
//       maxIteration: configs['maxIteration'],
//     );
//
//     return _knowledgeGenerator.imagePixels;
//   }
// }

/// Class for generating hashviz
final class HashVizTacitKnowledge implements TacitKnowledge {
  Hashviz _knowledgeGenerator;
  @override
  late Map<String, dynamic> configs;
  @override
  late TacitKnowledgeParam param;

  HashVizTacitKnowledge(
    this.configs,
    this.param,
  ) : _knowledgeGenerator = Hashviz(
          size: configs['size'] ?? 16, // TODO: Review default size
        );

  /// Returns a 3D visualization image of the hash.
  ///
  /// Returns image that represents the actual tacit knowledge of the
  /// [HashVizTacitKnowledge] tacit knowledge. Throws on [Exception]
  /// if the [TacitKnowledge.configs] or [TacitKnowledge.param] or both
  /// are empty because this will generate an insecure [TacitKnowledge].
  @override
  List<int> get knowledge {
    if (configs.isEmpty) {
      throw Exception(
        'The configs param is empty which is insecure argument. Please,'
        ' to get a correct and secure tacit knowledge, provide the'
        ' TacitKnowledge implementation with the correct configs argument.',
      );
    }

    _knowledgeGenerator = Hashviz(size: configs['size']!);
    List<int> knowledge =
        _knowledgeGenerator.generatePatternData(param.value.toString());

    return knowledge;
  }
}

class TacitKnowledgeFactory {
  static TacitKnowledge buildTacitKnowledgeFromType(
      TacitKnowledgeTypes type, Map<String, dynamic> configs) {
    switch (type) {
      case TacitKnowledgeTypes.formosa:
        return FormosaTacitKnowledge(
          configs,
          TacitKnowledgeParam(
            'formosaParam',
            Uint8List(128),
            Uint8List.fromList([]),
          ),
        );

      case TacitKnowledgeTypes.hashviz:
        return HashVizTacitKnowledge(
          configs,
          TacitKnowledgeParam(
            'hashvizParam',
            Uint8List(64),
            Uint8List.fromList([]),
          ),
        );

      default:
        throw ArgumentError('Unsupported tacit knowledge type: $type');
    }
  }
}
