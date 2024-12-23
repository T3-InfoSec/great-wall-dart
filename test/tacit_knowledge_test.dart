import 'dart:typed_data';

import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:test/test.dart';

void main() {
  group('TacitKnowledgeParam()', () {
    late TacitKnowledgeParam tacitKnowledgeParam;

    setUp(() {
      tacitKnowledgeParam = TacitKnowledgeParam(
        name: 'Param',
        initialState: Uint8List(128),
        adjustmentValue: Uint8List.fromList([1, 2, 3]),
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
        Uint8List.fromList([239, 2, 240, 89]),
      );
    });
  });

  group(
    'TacitKnowledge()',
    () {
      late Map<String, dynamic> formosaExpectedConfigs;
      late TacitKnowledgeParam formosaExpectedParam;
      late FormosaTacitKnowledge formosaTacitKnowledge;

      late Map<String, dynamic> fractalExpectedConfigs;
      late TacitKnowledgeParam fractalExpectedParam;
      late FractalTacitKnowledge fractalTacitKnowledge;

      late Map<String, dynamic> hashvizExpectedConfigs;
      late TacitKnowledgeParam hashvizExpectedParam;
      late HashVizTacitKnowledge hashvizTacitKnowledge;

      setUp(() {
        formosaExpectedConfigs = {'formosaTheme': FormosaTheme.bip39};
        formosaExpectedParam = TacitKnowledgeParam(
          name: 'formosaParam',
          initialState: Uint8List(128),
          adjustmentValue: Uint8List.fromList([0]),
        );
        formosaTacitKnowledge = FormosaTacitKnowledge(
          configs: formosaExpectedConfigs,
          param: formosaExpectedParam,
        );

        hashvizExpectedConfigs = {'hashvizSize': 16};
        hashvizExpectedParam = TacitKnowledgeParam(
          name: 'hashvizParam',
          initialState: Uint8List(128),
          adjustmentValue: Uint8List.fromList([1, 2, 3]),
        );
        hashvizTacitKnowledge = HashVizTacitKnowledge(
          configs: hashvizExpectedConfigs,
          param: hashvizExpectedParam,
        );

        fractalExpectedConfigs = {
          'funcType': 'burningship',
          'xMin': -2.5,
          'xMax': 2.0,
          'yMin': -2.0,
          'yMax': 0.8,
          'realP': 2.0,
          'imagP': 0.0,
          'width': 1024,
          'height': 1024,
          'escapeRadius': 4,
          'maxIters': 30,
        };
        fractalExpectedParam = TacitKnowledgeParam(
          name: 'realParam',
          initialState: Uint8List(128),
          adjustmentValue: Uint8List.fromList([0]),
        );
        fractalTacitKnowledge = FractalTacitKnowledge(
          configs: fractalExpectedConfigs,
          param: fractalExpectedParam,
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

      test('could use FractalTacitKnowledge constructor', () {
        expect(fractalTacitKnowledge.configs, fractalExpectedConfigs);
        expect(fractalTacitKnowledge.param, fractalExpectedParam);
      });

      test('could be able to return underline knowledge', () {
        expect(formosaTacitKnowledge.knowledge, 'talk mutual diagram');
        expect(hashvizTacitKnowledge.knowledge, [
          1, 0, 1, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 1, 0, 1, 0, 2, 1, 
          2, 1, 2, 0, 1, 1, 0, 2, 1, 2, 1, 2, 0, 0, 0, 1, 2, 2, 2, 
          1, 2, 2, 1, 2, 2, 2, 1, 0, 0, 1, 2, 2, 2, 2, 0, 1, 1, 1, 
          1, 0, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, 0, 1, 2, 2, 1, 0, 2, 
          1, 2, 2, 2, 2, 2, 2, 0, 2, 0, 2, 1, 1, 2, 0, 2, 0, 2, 2, 
          2, 0, 0, 1, 0, 2, 2, 1, 0, 0, 1, 2, 2, 0, 1, 0, 0, 2, 2, 
          0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 1, 2, 
          2, 1, 0, 0, 1, 2, 2, 1, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2, 0, 
          0, 2, 2, 2, 0, 2, 0, 2, 1, 1, 1, 0, 1, 2, 0, 2, 2, 0, 2, 
          1, 0, 1, 1, 1, 2, 1, 2, 1, 0, 2, 1, 2, 2, 1, 2, 0, 1, 2, 
          1, 2, 0, 1, 2, 2, 1, 0, 2, 2, 2, 2, 0, 1, 2, 2, 1, 0, 0, 
          1, 2, 2, 0, 2, 0, 2, 2, 0, 2, 0, 2, 2, 1, 0, 1, 0, 1, 2, 
          2, 2, 1, 1, 1, 1, 2, 2, 2, 1, 0, 1, 2, 0, 0, 1, 0, 1, 2, 
          1, 1, 2, 1, 0, 1, 0, 0, 2]);
        expect(fractalTacitKnowledge.knowledge, isNotNull);
      });

      test('with not provided param return null', () {
        formosaExpectedConfigs = {'formosaTheme': FormosaTheme.bip39};
        formosaTacitKnowledge = FormosaTacitKnowledge(
          configs: formosaExpectedConfigs,
        );

        fractalExpectedConfigs = {
          'funcType': 'burningship',
          'xMin': -2.5,
          'xMax': 2.0,
          'yMin': -2.0,
          'yMax': 0.8,
          'realP': 2.0,
          'imagP': 0.0,
          'width': 1024,
          'height': 1024,
          'escapeRadius': 4,
          'maxIters': 30,
        };
        fractalTacitKnowledge = FractalTacitKnowledge(
          configs: fractalExpectedConfigs,
        );

        hashvizExpectedConfigs = {'hashvizSize': 16};
        hashvizTacitKnowledge = HashVizTacitKnowledge(
          configs: hashvizExpectedConfigs,
        );

        expect(formosaTacitKnowledge.knowledge, isNull);
        expect(hashvizTacitKnowledge.knowledge, isNull);
        expect(fractalTacitKnowledge.knowledge, isNull);
      });
    },
  );
}
