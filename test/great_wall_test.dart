import 'dart:typed_data';

import 'package:great_wall/great_wall.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:test/test.dart';

void main() {
  group('GreatWall()', () {
    late GreatWall greatwallProtocol;

    // late Map<String, dynamic> fractalExpectedConfigs;
    // late TacitKnowledgeParam fractalExpectedParam;
    // late FractalTacitKnowledge fractalTacitKnowledge;

    setUp(() {
      Map<String, dynamic> configs = {'formosaTheme': FormosaTheme.bip39};

      greatwallProtocol = GreatWall(
        treeArity: 3,
        treeDepth: 5,
        timeLockPuzzleParam: 10,
        tacitKnowledge: FormosaTacitKnowledge(configs: configs),
      );
    });

    test('should use constructor', () {
      expect(GreatWall.bytesCount, 4);

      expect(greatwallProtocol.treeArity, 3);
      expect(greatwallProtocol.treeDepth, 5);
      expect(greatwallProtocol.timeLockPuzzleParam, 10);
      expect(greatwallProtocol.currentHash, Uint8List(128));
      expect(greatwallProtocol.derivationLevel, 0);
      expect(greatwallProtocol.derivationHashResult, isNull);
      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isFalse);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);

      expect(
        greatwallProtocol.derivationTacitKnowledge,
        isA<FormosaTacitKnowledge>(),
      );
    });

    test('flow could be start', () {
      greatwallProtocol.startDerivation();

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isTrue);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
      expect(greatwallProtocol.currentHash, [
          194, 115, 189, 160, 109, 180, 101, 153, 231, 56, 199, 157, 63, 150, 3,
          58, 81, 14, 2, 240, 77, 242, 122, 67, 109, 186, 255, 242, 41, 122, 88, 
          246, 227, 76, 175, 34, 179, 71, 53, 247, 208, 101, 91, 62, 160, 156, 
          182, 94, 25, 13, 51, 117, 202, 101, 142, 104, 147, 153, 204, 151, 202, 
          169, 183, 51, 92, 45, 109, 158, 19, 11, 210, 193, 28, 123, 142, 125, 49, 37,
          56, 86, 30, 108, 2, 40, 53, 14, 182, 38, 159, 58, 8, 61, 39, 54, 48, 16, 
          41, 128, 198, 242, 153, 128, 155, 226, 152, 75, 130, 244, 151, 62, 247, 
          145, 23, 152, 114, 179, 203, 236, 48, 249, 197, 23, 23, 153, 229, 182, 219, 233
        ]);
    });

    test('could get generated level knowledge palettes', () {
      greatwallProtocol.startDerivation();
      List<TacitKnowledge> knowledgePalettes =
          greatwallProtocol.currentLevelKnowledgePalettes;
      expect(knowledgePalettes.length, greatwallProtocol.treeArity);
      expect(knowledgePalettes[0], isA<FormosaTacitKnowledge>());
      expect(knowledgePalettes[1], isA<FormosaTacitKnowledge>());
      expect(knowledgePalettes[2], isA<FormosaTacitKnowledge>());

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isTrue);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
      expect(greatwallProtocol.currentHash, [
          194, 115, 189, 160, 109, 180, 101, 153, 231, 56, 199, 157, 63, 150, 3,
          58, 81, 14, 2, 240, 77, 242, 122, 67, 109, 186, 255, 242, 41, 122, 88, 
          246, 227, 76, 175, 34, 179, 71, 53, 247, 208, 101, 91, 62, 160, 156, 
          182, 94, 25, 13, 51, 117, 202, 101, 142, 104, 147, 153, 204, 151, 202, 
          169, 183, 51, 92, 45, 109, 158, 19, 11, 210, 193, 28, 123, 142, 125, 49, 37,
          56, 86, 30, 108, 2, 40, 53, 14, 182, 38, 159, 58, 8, 61, 39, 54, 48, 16, 
          41, 128, 198, 242, 153, 128, 155, 226, 152, 75, 130, 244, 151, 62, 247, 
          145, 23, 152, 114, 179, 203, 236, 48, 249, 197, 23, 23, 153, 229, 182, 219, 233
        ]);
    });

    test('could using tacit knowledge derivation', () {
      greatwallProtocol.startDerivation();
      greatwallProtocol.makeTacitDerivation(choiceNumber: 0);
      expect(greatwallProtocol.currentHash, [
          194, 115, 189, 160, 109, 180, 101, 153, 231, 56, 199, 157, 63, 150, 3,
          58, 81, 14, 2, 240, 77, 242, 122, 67, 109, 186, 255, 242, 41, 122, 88, 
          246, 227, 76, 175, 34, 179, 71, 53, 247, 208, 101, 91, 62, 160, 156, 
          182, 94, 25, 13, 51, 117, 202, 101, 142, 104, 147, 153, 204, 151, 202, 
          169, 183, 51, 92, 45, 109, 158, 19, 11, 210, 193, 28, 123, 142, 125, 49, 37,
          56, 86, 30, 108, 2, 40, 53, 14, 182, 38, 159, 58, 8, 61, 39, 54, 48, 16, 
          41, 128, 198, 242, 153, 128, 155, 226, 152, 75, 130, 244, 151, 62, 247, 
          145, 23, 152, 114, 179, 203, 236, 48, 249, 197, 23, 23, 153, 229, 182, 219, 233
        ]);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 1);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 2);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 3);

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isTrue);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
    });

    test('flow could cancel the current running derivation', () {
      greatwallProtocol.startDerivation();
      greatwallProtocol.makeTacitDerivation(choiceNumber: 0);
      greatwallProtocol.cancelDerivation();

      expect(greatwallProtocol.isCanceled, isTrue);
      expect(greatwallProtocol.isStarted, isFalse);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
    });

    test('flow could be finish derivation successfully', () {
      greatwallProtocol.startDerivation();
      greatwallProtocol.makeTacitDerivation(choiceNumber: 0);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 1);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 2);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 3);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 1);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 2);
      greatwallProtocol.finishDerivation();

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isTrue);
      expect(greatwallProtocol.isFinished, isTrue);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNotNull);
    });

    test('flow could handle finish incomplete derivation', () {
      greatwallProtocol.startDerivation();
      greatwallProtocol.makeTacitDerivation(choiceNumber: 0);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 1);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 2);
      greatwallProtocol.finishDerivation();

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isTrue);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
    });

    test('flow could handle finish did not started tacit derivation', () {
      greatwallProtocol.finishDerivation();

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isFalse);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
    });
  });
}
