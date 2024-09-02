import 'dart:typed_data';

import 'package:great_wall/src/great_wall_protocol.dart';
import 'package:great_wall/src/tacit_knowledge_impl.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:test/test.dart';

void main() {
  group('GreatWall()', () {
    late GreatWall greatwallProtocol;

    // late Map<String, dynamic> fractalExpectedConfigs;
    // late TacitKnowledgeParam fractalExpectedParam;
    // late FractalTacitKnowledge fractalTacitKnowledge;

    setUp(() {
      greatwallProtocol = GreatWall(
        treeArity: 3,
        treeDepth: 5,
        timeLockPuzzleParam: 10,
        tacitKnowledgeType: TacitKnowledgeTypes.formosa,
        tacitKnowledgeConfigs: {'formosaTheme': FormosaTheme.bip39},
      );
    });

    test('should use constructor', () {
      expect(GreatWall.argon2Salt, Uint8List(32));
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
        137, 143, 186, 18, 167, 0, 209, 173, 77, 196, 218, 89, 207, 51, 250,
        144, 152, 162, 136, 237, 157, 39, 32, 136, 188, 239, 171, 44, 4, 129,
        22, 25, 119, 115, 153, 235, 115, 5, 16, 107, 83, 193, 136, 106, 32,
        62, 235, 145, 77, 240, 24, 243, 196, 50, 94, 85, 40, 102, 187, 15, 207,
        234, 215, 131, 53, 56, 190, 180, 183, 54, 6, 65, 197, 185, 138, 98,
        129, 173, 37, 216, 76, 249, 255, 129, 67, 74, 128, 190, 248, 38, 111,
        163, 255, 123, 247, 131, 26, 48, 130, 202, 116, 216, 183, 71, 101, 94,
        117, 102, 99, 248, 36, 144, 144, 148, 92, 54, 7, 249, 82, 80, 79, 251,
        41, 211, 155, 130, 154, 192, // Current state of the derivation.
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
        137, 143, 186, 18, 167, 0, 209, 173, 77, 196, 218, 89, 207, 51, 250,
        144, 152, 162, 136, 237, 157, 39, 32, 136, 188, 239, 171, 44, 4, 129,
        22, 25, 119, 115, 153, 235, 115, 5, 16, 107, 83, 193, 136, 106, 32,
        62, 235, 145, 77, 240, 24, 243, 196, 50, 94, 85, 40, 102, 187, 15, 207,
        234, 215, 131, 53, 56, 190, 180, 183, 54, 6, 65, 197, 185, 138, 98,
        129, 173, 37, 216, 76, 249, 255, 129, 67, 74, 128, 190, 248, 38, 111,
        163, 255, 123, 247, 131, 26, 48, 130, 202, 116, 216, 183, 71, 101, 94,
        117, 102, 99, 248, 36, 144, 144, 148, 92, 54, 7, 249, 82, 80, 79, 251,
        41, 211, 155, 130, 154, 192, // Current state of the derivation.
      ]);
    });

    test('could using tacit knowledge derivation', () {
      greatwallProtocol.startDerivation();
      greatwallProtocol.makeTacitDerivation(choiceNumber: 0);
      expect(greatwallProtocol.currentHash, [
        137, 143, 186, 18, 167, 0, 209, 173, 77, 196, 218, 89, 207, 51, 250,
        144, 152, 162, 136, 237, 157, 39, 32, 136, 188, 239, 171, 44, 4, 129,
        22, 25, 119, 115, 153, 235, 115, 5, 16, 107, 83, 193, 136, 106, 32,
        62, 235, 145, 77, 240, 24, 243, 196, 50, 94, 85, 40, 102, 187, 15, 207,
        234, 215, 131, 53, 56, 190, 180, 183, 54, 6, 65, 197, 185, 138, 98,
        129, 173, 37, 216, 76, 249, 255, 129, 67, 74, 128, 190, 248, 38, 111,
        163, 255, 123, 247, 131, 26, 48, 130, 202, 116, 216, 183, 71, 101, 94,
        117, 102, 99, 248, 36, 144, 144, 148, 92, 54, 7, 249, 82, 80, 79, 251,
        41, 211, 155, 130, 154, 192, // Current state of the derivation.
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
