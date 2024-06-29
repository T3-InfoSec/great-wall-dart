import 'dart:typed_data';

import 'package:great_wall/src/tacit_knowledge.dart';
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

  group(
    'Tacit knowledge tests',
    () {
      late Map<String, dynamic> formosaExpectedConfigs;
      late Map<String, FormosaTacitKnowledgeParam> formosaExpectedParams;
      late Map<String, dynamic> fractalExpectedConfigs;
      late Map<String, FractalTacitKnowledgeParam> fractalExpectedParams;
      // late Map<String, dynamic> hashvizExpectedConfigs;
      // late Map<String, HahVizTacitKnowledgeParam> hashvizExpectedParams;

      late FormosaTacitKnowledge formosaTacitKnowledge;
      late FractalTacitKnowledge fractalTacitKnowledge;
      // late HashVizTacitKnowledge hashvizTacitKnowledge;

      setUp(() {
        formosaExpectedConfigs = {'theme': 'BiP39'};
        formosaExpectedParams = {
          'formosaParam': FormosaTacitKnowledgeParam(
            'formosaParam',
            Uint8List(128),
            Uint8List.fromList([0]),
          )
        };
        fractalExpectedConfigs = {
          'fractalSet': 'burningship',
          'colorScheme': 'gray',
          'xMin': 0,
          'xMax': 0,
          'yMin': 0,
          'yMax': 0,
          'width': 2,
          'height': 2,
          'escapeRadius': 4,
          'maxIteration': 100,
        };
        fractalExpectedParams = {
          'realParam': FractalTacitKnowledgeParam(
            'realParam',
            Uint8List(128),
            Uint8List.fromList([0]),
          ),
          'imaginaryParam': FractalTacitKnowledgeParam(
            'realParam',
            Uint8List(128),
            Uint8List.fromList([0]),
          ),
        };

        formosaTacitKnowledge = FormosaTacitKnowledge(
          formosaExpectedConfigs,
          formosaExpectedParams,
        );
        fractalTacitKnowledge = FractalTacitKnowledge(
          fractalExpectedConfigs,
          fractalExpectedParams,
        );
      });

      test('Constructors', () {
        expect(formosaTacitKnowledge.configs, formosaExpectedConfigs);
        expect(formosaTacitKnowledge.params, formosaExpectedParams);

        expect(fractalTacitKnowledge.configs, fractalExpectedConfigs);
        expect(fractalTacitKnowledge.params, fractalExpectedParams);
      });

      test('Get underline knowledge', () {
        // TODO: Change the expected result to what actually produced by
        // knowledge.
        expect(formosaTacitKnowledge.knowledge, [57, 116, 180, 27].toString());
        expect(fractalTacitKnowledge.knowledge, [1, 2, 3]);
      });
    },
    skip: 'The implementation of knowledge generator still under development.',
  );
}
