import 'dart:typed_data';

import 'package:great_wall/src/tacit_knowledge_impl.dart';
import 'package:test/test.dart';

void main() {
  group('TacitKnowledgeParam()', () {
    late TacitKnowledgeParam tacitKnowledgeParam;

    setUp(() {
      tacitKnowledgeParam = TacitKnowledgeParam(
        'Param',
        Uint8List(128),
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('could construct TacitKnowledgeParam', () {
      expect(tacitKnowledgeParam.name, 'Param');
      expect(tacitKnowledgeParam.initialState, Uint8List(128));
      expect(
        tacitKnowledgeParam.adjustmentValue,
        Uint8List.fromList([1, 2, 3]),
      );
    });

    test('could return TacitKnowledgeParam value', () {
      expect(
        tacitKnowledgeParam.value,
        Uint8List.fromList([161, 61, 31, 99]),
      );
    });
  });

  group(
    'TacitKnowledge()',
    () {
      late Map<String, dynamic> formosaExpectedConfigs;
      late TacitKnowledgeParam formosaExpectedParam;
      late Map<String, dynamic> fractalExpectedConfigs;
      late TacitKnowledgeParam fractalExpectedParam;
      // late Map<String, dynamic> hashvizExpectedConfigs;
      // late TacitKnowledgeParam hashvizExpectedParam;

      late FormosaTacitKnowledge formosaTacitKnowledge;
      late FractalTacitKnowledge fractalTacitKnowledge;
      // late HashVizTacitKnowledge hashvizTacitKnowledge;

      setUp(() {
        formosaExpectedConfigs = {'theme': 'BiP39'};
        formosaExpectedParam = TacitKnowledgeParam(
          'formosaParam',
          Uint8List(128),
          Uint8List.fromList([0]),
        );
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
        fractalExpectedParam = TacitKnowledgeParam(
          'realParam',
          Uint8List(128),
          Uint8List.fromList([0]),
        );

        formosaTacitKnowledge = FormosaTacitKnowledge(
          formosaExpectedConfigs,
          formosaExpectedParam,
        );
        fractalTacitKnowledge = FractalTacitKnowledge(
          fractalExpectedConfigs,
          fractalExpectedParam,
        );
      });

      test('could use constructors', () {
        expect(formosaTacitKnowledge.configs, formosaExpectedConfigs);
        expect(formosaTacitKnowledge.param, formosaExpectedParam);

        expect(fractalTacitKnowledge.configs, fractalExpectedConfigs);
        expect(fractalTacitKnowledge.param, fractalExpectedParam);
      });

      test('could be able to return underline knowledge', () {
        // TODO: Change the expected result to what actually produced by
        // knowledge.
        expect(formosaTacitKnowledge.knowledge, [1, 2, 3].toString());
        expect(fractalTacitKnowledge.knowledge, [1, 2, 3]);
      });
    },
    skip: 'The implementation of knowledge generator still under development.',
  );
}
