import 'dart:typed_data';

import 'package:great_wall/src/tacit_knowledge_impl.dart';
import 'package:great_wall/src/tacit_knowledge_types.dart';
import 'package:t3_formosa/formosa.dart';
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
    'TacitKnowledge()', () {
      late Map<String, dynamic> formosaExpectedConfigs;
      late TacitKnowledgeParam formosaExpectedParam;
      // late Map<String, dynamic> fractalExpectedConfigs;
      // late TacitKnowledgeParam fractalExpectedParam;
      late Map<String, dynamic> hashvizExpectedConfigs;
      late TacitKnowledgeParam hashvizExpectedParam;

      late FormosaTacitKnowledge formosaTacitKnowledge;
      // late FractalTacitKnowledge fractalTacitKnowledge;
      late HashVizTacitKnowledge hashvizTacitKnowledge;

      setUp(() {
        formosaExpectedConfigs = {'formosaTheme': FormosaTheme.bip39};
        formosaExpectedParam = TacitKnowledgeParam(
          'formosaParam',
          Uint8List(128),
          Uint8List.fromList([0]),
        );
        // fractalExpectedConfigs = {
        //   'fractalSet': 'burningship',
        //   'colorScheme': 'gray',
        //   'xMin': 0,
        //   'xMax': 0,
        //   'yMin': 0,
        //   'yMax': 0,
        //   'width': 2,
        //   'height': 2,
        //   'escapeRadius': 4,
        //   'maxIteration': 100,
        // };
        // fractalExpectedParam = TacitKnowledgeParam(
        //   'realParam',
        //   Uint8List(128),
        //   Uint8List.fromList([0]),
        // );
        hashvizExpectedConfigs = {
          'size': 16,
          'isSymmetric': false,
          'numColors': 3,
        };
        hashvizExpectedParam = TacitKnowledgeParam(
          'hashvizParam',
          Uint8List(128),
          Uint8List.fromList([1, 2, 3]),
        );

        formosaTacitKnowledge = FormosaTacitKnowledge(
          formosaExpectedConfigs,
          formosaExpectedParam,
        );
        // fractalTacitKnowledge = FractalTacitKnowledge(
        //   fractalExpectedConfigs,
        //   fractalExpectedParam,
        // );
        hashvizTacitKnowledge = HashVizTacitKnowledge(
          hashvizExpectedConfigs,
          hashvizExpectedParam,
        );
      });

      test('could use FormosaTacitKnowledge constructor', () {
        expect(formosaTacitKnowledge.configs, formosaExpectedConfigs);
        expect(formosaTacitKnowledge.param, formosaExpectedParam);
      });

      test('could use HashVizTacitKnowledge constructor', () {
        expect(hashvizTacitKnowledge.configs, hashvizExpectedConfigs);
        expect(hashvizTacitKnowledge.param, hashvizExpectedParam);
      });

      test('could be able to return underline knowledge', () {
        // TODO: Change the expected result to what actually produced by
        // knowledge.
        expect(formosaTacitKnowledge.knowledge, 'defense pizza almost');
        // expect(fractalTacitKnowledge.knowledge, [1, 2, 3]);
        List<int> expectedImageData = [1, 0, 1, 2, 1, 2, 1, 2, 0, 1, 2, 1, 2, 0, 1, 2, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 2, 0, 2, 0, 0, 0, 2, 2, 2, 1, 2, 1, 0, 2, 2, 2, 2, 1, 0, 2, 2, 0, 2, 2, 1, 0, 0, 1, 1, 2, 2, 2, 0, 0, 0, 0, 1, 1, 2, 0, 1, 0, 2, 1, 1, 2, 2, 1, 0, 2, 0, 0, 1, 1, 1, 1, 2, 0, 1, 0, 2, 0, 1, 2, 0, 0, 1, 0, 1, 2, 2, 2, 2, 2, 0, 1, 2, 2, 2, 1, 0, 0, 0, 2, 1, 2, 1, 0, 1, 1, 2, 2, 0, 2, 0, 0, 1, 1, 0, 2, 2, 0, 1, 1, 2, 2, 2, 0, 2, 2, 2, 1, 0, 0, 2, 0, 2, 2, 1, 0, 2, 0, 2, 1, 2, 1, 2, 2, 1, 1, 0, 2, 1, 1, 1, 1, 0, 0, 1, 0, 2, 0, 0, 2, 0, 2, 1, 2, 1, 1, 2, 0, 2, 0, 2, 0, 2, 0, 2, 1, 2, 1, 2, 0, 2, 1, 2, 2, 0, 2, 2, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 2, 0, 2, 0, 0, 1, 0, 2, 0, 1, 2, 0, 2, 1, 2, 1, 2, 0, 1, 0, 1, 1, 1, 1, 1, 2, 2, 2, 0, 2, 0, 2, 1, 0, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 0];
        expect(hashvizTacitKnowledge.knowledge, expectedImageData);
      });

      test('buildTacitKnowledgeFromType() should return correct TacitKnowledge',
          () {
        final formosaTacit = TacitKnowledgeFactory.buildTacitKnowledgeFromType(
          TacitKnowledgeTypes.formosa,
          formosaExpectedConfigs,
        );
        final hashvizTacit = TacitKnowledgeFactory.buildTacitKnowledgeFromType(
          TacitKnowledgeTypes.hashviz,
          hashvizExpectedConfigs,
        );

        expect(formosaTacit, isA<FormosaTacitKnowledge>());
        expect(hashvizTacit, isA<HashVizTacitKnowledge>());
      });
    },
    // skip: 'The implementation of knowledge generator still under development.',
  );
}
