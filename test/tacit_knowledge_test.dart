import 'dart:typed_data';

import 'package:great_wall/src/tacit_knowledge.dart';
import 'package:great_wall/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tacit knowledge params tests', () {
    late FormosaTacitKnowledgeParam formosaTacitKnowledgeParam;
    late FractalTacitKnowledgeParam realFractalTacitKnowledgeParam;
    late FractalTacitKnowledgeParam imaginaryFractalTacitKnowledgeParam;
    late FractalTacitKnowledgeParam generalFractalTacitKnowledgeParam;
    // late HashVizTacitKnowledgeParam hashvizTacitKnowledgeParam;

    setUp(() {
      formosaTacitKnowledgeParam = FormosaTacitKnowledgeParam(
        'arityIdx',
        Uint8List(128),
        Uint8List.fromList([0]),
      );

      realFractalTacitKnowledgeParam = FractalTacitKnowledgeParam(
        "realParam",
        Uint8List(128),
        Uint8List.fromList([1, 2, 3]),
      );

      imaginaryFractalTacitKnowledgeParam = FractalTacitKnowledgeParam(
        "imaginaryParam",
        Uint8List(128),
        Uint8List.fromList([1, 2, 3]),
      );

      generalFractalTacitKnowledgeParam = FractalTacitKnowledgeParam(
        "generalParam",
        Uint8List(128),
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('Formosa Param Constructor', () {
      expect(formosaTacitKnowledgeParam.name, 'arityIdx');
      expect(formosaTacitKnowledgeParam.initialState, Uint8List(128));
      expect(
        formosaTacitKnowledgeParam.adjustmentValue,
        Uint8List.fromList([0]),
      );
    });

    test('Fractal Param Constructor', () {
      expect(realFractalTacitKnowledgeParam.name, 'realParam');
      expect(realFractalTacitKnowledgeParam.initialState, Uint8List(128));
      expect(
        realFractalTacitKnowledgeParam.adjustmentValue,
        Uint8List.fromList([1, 2, 3]),
      );

      expect(imaginaryFractalTacitKnowledgeParam.name, 'imaginaryParam');
      expect(imaginaryFractalTacitKnowledgeParam.initialState, Uint8List(128));
      expect(
        imaginaryFractalTacitKnowledgeParam.adjustmentValue,
        Uint8List.fromList([1, 2, 3]),
      );

      expect(generalFractalTacitKnowledgeParam.name, 'generalParam');
      expect(generalFractalTacitKnowledgeParam.initialState, Uint8List(128));
      expect(
        generalFractalTacitKnowledgeParam.adjustmentValue,
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('Formosa Param value', () {
      expect(
        formosaTacitKnowledgeParam.value,
        Uint8List.fromList([57, 116, 180, 27]),
      );
    });

    test('Fractal Param value', () {
      expect(realFractalTacitKnowledgeParam.value, 2.993161161);
      expect(imaginaryFractalTacitKnowledgeParam.value, 0.993161161);
      expect(generalFractalTacitKnowledgeParam.value, 2.993161161);
    });
  });

  group('Tacit knowledge tests', () {
    // late FormosaTacitKnowledge formosaTacitKnowledge;
    // late FractalTacitKnowledge fractalTacitKnowledge;
    // // late HashVizTacitKnowledge hashvizTacitKnowledge;
    //
    // late DerivationPath derivationPath;
    //
    // setUp(() {
    //   derivationPath = DerivationPath(nodesList: [1, 2, 3]);
    // });
  });
}
