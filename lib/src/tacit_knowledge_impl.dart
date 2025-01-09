// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:typed_data';

import 'package:fractal/fractal.dart';
import 'package:hashlib/hashlib.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_hashviz/hashviz.dart';

/// A tacit knowledge param that can be passed for any tacit knowledge
/// type as a parameter to tweak (in a tacit way) the tacit knowledge.
final class TacitKnowledgeParam {
  static final Uint8List argon2Salt = Uint8List(32);
  static final int bytesCount = 4;

  final String name;
  final Uint8List initialState;
  final Uint8List adjustmentValue;

  TacitKnowledgeParam({
    required this.name,
    required this.initialState,
    required this.adjustmentValue,
  });

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
      memorySizeKB: 10 * 1024,
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
  late TacitKnowledgeParam? param;

  Object? get knowledge;
}

/// A class that can be instantiated to create a formosa tacit knowledge.
final class FormosaTacitKnowledge implements TacitKnowledge {
  late Formosa _knowledgeGenerator;

  @override
  Map<String, dynamic> configs;

  @override
  TacitKnowledgeParam? param;

  FormosaTacitKnowledge({required this.configs, this.param});

  /// Returns a mnemonic string.
  ///
  /// Returns the mnemonic string that represents the actual tacit knowledge
  /// of the [FormosaTacitKnowledge] tacit knowledge or `null` if the [param]
  /// is not provided. Throws on [Exception] if the [TacitKnowledge.configs]
  /// is empty because this will generate an insecure [TacitKnowledge].
  @override
  String? get knowledge {
    if (configs.isEmpty) {
      throw Exception(
        'The configs param is empty which is insecure argument. Please,'
        ' to get a correct and secure tacit knowledge, provide the'
        ' TacitKnowledge implementation with the correct configs argument.',
      );
    }

    if (param == null) {
      return null;
    }

    _knowledgeGenerator = Formosa(param!.value, configs['formosaTheme']!);
    String knowledge = _knowledgeGenerator.mnemonic;

    return knowledge;
  }
}

/// A class that can be instantiated to create a fractal tacit knowledge.
final class FractalTacitKnowledge implements TacitKnowledge {
  late Fractal _knowledgeGenerator;

  @override
  Map<String, dynamic> configs;

  @override
  TacitKnowledgeParam? param;

  FractalTacitKnowledge({required this.configs, this.param});

  /// Returns an static fractal image.
  ///
  /// Returns the image that represents the actual tacit knowledge of the
  /// [FractalTacitKnowledge] tacit knowledge or `null` if the [param] is
  /// not provided. Throws on [Exception] if the [TacitKnowledge.configs]
  /// is empty because this will generate an insecure [TacitKnowledge].
  @override
  Future<Uint8List> get knowledge async {
    if (configs.isEmpty) {
      throw Exception(
        'The configs param is empty which is insecure argument. Please,'
        ' to get a correct and secure tacit knowledge, provide the'
        ' TacitKnowledge implementation with the correct configs argument.',
      );
    }

    // NOTE: Inverting the order of digits to minimize Benford's law bias.
    String realParam = '2.${int.parse(param!.value.reversed.join())}';
    String imaginaryParam = '0.${int.parse(param!.value.reversed.join())}';
    Map<String, double> params = {
      'realParam': double.parse(realParam),
      'imaginaryParam': double.parse(imaginaryParam)
    };

    _knowledgeGenerator = Fractal(
      xMin: configs['xMin'] ?? -2.5,
      xMax: configs['xMax'] ?? 2.0,
      yMin: configs['yMin'] ?? -2.0,
      yMax: configs['yMax'] ?? 0.8,
      realP: params['realParam']!,
      imagP: params['imaginaryParam']!,
      width: configs['width'] ?? 1024,
      height: configs['height'] ?? 1024,
      escapeRadius: configs['escapeRadius'] ?? 4,
      maxIters: configs['maxIters'] ?? 30,
    );

    _knowledgeGenerator.update();

    Future<Uint8List> imagePixels = _knowledgeGenerator.burningshipSet();
    Uint8List frames = await imagePixels;

    return frames;
  }
}

/// A class that can be instantiated to create a fractal tacit knowledge.
final class AnimatedFractalTacitKnowledge implements TacitKnowledge {
  late Fractal _knowledgeGenerator;

  @override
  Map<String, dynamic> configs;

  @override
  TacitKnowledgeParam? param;

  AnimatedFractalTacitKnowledge({required this.configs, this.param});

  /// Returns an static fractal image.
  ///
  /// Returns the image that represents the actual tacit knowledge of the
  /// [FractalTacitKnowledge] tacit knowledge or `null` if the [param] is
  /// not provided. Throws on [Exception] if the [TacitKnowledge.configs]
  /// is empty because this will generate an insecure [TacitKnowledge].
  @override
  Future<List<Uint8List>> get knowledge {
    if (configs.isEmpty) {
      throw Exception(
        'The configs param is empty which is insecure argument. Please,'
        ' to get a correct and secure tacit knowledge, provide the'
        ' TacitKnowledge implementation with the correct configs argument.',
      );
    }
    if (param?.value == null || param!.value.isEmpty) {
      throw Exception(
          'Param value is empty or null. Cannot generate knowledge.');
    }

    // Extract reversed value as a base value
    String reversedValue = param!.value.reversed.join();
    double baseValue = double.parse('0.$reversedValue');
    double frequencyK = (baseValue * 10) % 4;
    double frequencyL =
        (double.parse((baseValue * 100).toString().substring(1))) % 4;

    // Calculate parameters
    double phaseOffset = (baseValue * 10) % 6.28;
    double realParam = 2 + baseValue;
    double imaginaryParam = baseValue;

    Map<String, double> params = {
      'phaseOffset': phaseOffset,
      'frequencyK': frequencyK,
      'frequencyL': frequencyL,
      'realParam': realParam,
      'imaginaryParam': imaginaryParam
    };

    print(params);

    _knowledgeGenerator = Fractal(
      funcType: Fractal.burningShip,
      realP: params['realParam']!,
      imagP: params['imaginaryParam']!,
      width: configs['width'] ?? 300,
      height: configs['height'] ?? 300,
      xMin: configs['xMin'] ?? -2.5,
      xMax: configs['xMax'] ?? 2.0,
      yMin: configs['yMin'] ?? -2.0,
      yMax: configs['yMax'] ?? 0.8,
      escapeRadius: configs['escapeRadius'] ?? 4,
      maxIters: configs['maxIters'] ?? 30,
    );

    _knowledgeGenerator.update();

    return _knowledgeGenerator.generateAnimation(
        n: configs['n'],
        A: configs['A'],
        B: configs['B'],
        phi: params['phaseOffset']!,
        k: params['frequencyK']!,
        l: params['frequencyL']!);
  }
}

/// A class that can be instantiated to create a formosa tacit knowledge.
final class HashVizTacitKnowledge implements TacitKnowledge {
  late Hashviz _knowledgeGenerator;

  @override
  Map<String, dynamic> configs;

  @override
  TacitKnowledgeParam? param;

  HashVizTacitKnowledge({required this.configs, this.param});

  /// Returns an image of the hash.
  ///
  /// Returns the image that represents the actual tacit knowledge of the
  /// [HashVizTacitKnowledge] tacit knowledge or `null` if the [param] is not
  /// provided. Throws on [Exception] if the [TacitKnowledge.configs] is empty
  /// because this will generate an insecure [TacitKnowledge].
  @override
  List<int>? get knowledge {
    if (configs.isEmpty) {
      throw Exception(
        'The configs param is empty which is insecure argument. Please,'
        ' to get a correct and secure tacit knowledge, provide the'
        ' TacitKnowledge implementation with the correct configs argument.',
      );
    }

    if (param == null) {
      return null;
    }

    _knowledgeGenerator = Hashviz(
        hashToVisualize: param!.value.toString(),
        visualizationSize: configs['hashvizSize']!,
        isSymmetric: configs['isSymmetric'] ?? true,
        numColors: configs['numColors'] ?? 3);
    List<int> knowledge = _knowledgeGenerator.visualizationBlocks;

    return knowledge;
  }
}
