import 'dart:typed_data';

import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
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
        timeLockPuzzleParam: 1,
        tacitKnowledge: FormosaTacitKnowledge(configs: configs),
      );
      greatwallProtocol.initializeDerivation(Sa0(Formosa(Uint8List(128), FormosaTheme.bip39)), []);
    });

    test('should use constructor', () {
      expect(GreatWall.bytesCount, 4);

      expect(greatwallProtocol.treeArity, 3);
      expect(greatwallProtocol.treeDepth, 5);
      expect(greatwallProtocol.timeLockPuzzleParam, 1);
      expect(greatwallProtocol.currentNode.value, Uint8List(128));
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

  test('flow could be start', () async {
      await greatwallProtocol.startDerivation();

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isTrue);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
      expect(greatwallProtocol.currentNode.value, [
        167, 249, 103, 124, 188, 123, 51, 168, 247, 61, 208, 84, 232, 40, 39, 6,
        1, 241, 91, 103, 231, 157, 236, 101, 146, 108, 180, 102, 54, 232, 180, 175,
        80, 139, 99, 120, 219, 3, 29, 254, 254, 160, 164, 115, 230, 195, 33, 223,
        43, 236, 123, 37, 100, 5, 105, 1, 113, 57, 117, 51, 53, 112, 36, 197, 219,
        166, 15, 101, 26, 31, 243, 137, 52, 47, 44, 189, 67, 5, 28, 234, 94, 239,
        222, 32, 175, 24, 3, 30, 214, 9, 87, 236, 235, 11, 188, 49, 17, 242, 36, 8,
        150, 153, 232, 93, 252, 60, 53, 0, 102, 41, 113, 198, 244, 35, 17, 186, 71,
        98, 175, 193, 171, 13, 34, 164, 74, 185, 32, 132]);
    });

    test('could get generated level knowledge palettes', () async {
      await greatwallProtocol.startDerivation();
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
      expect(greatwallProtocol.currentNode.value, [167, 249, 103, 124, 188, 123, 51, 168,
      247, 61, 208, 84, 232, 40, 39, 6, 1, 241, 91, 103, 231, 157, 236, 101, 146, 108, 180,
      102, 54, 232, 180, 175, 80, 139, 99, 120, 219, 3, 29, 254, 254, 160, 164, 115, 230,
      195, 33, 223, 43, 236, 123, 37, 100, 5, 105, 1, 113, 57, 117, 51, 53, 112, 36, 197,
      219, 166, 15, 101, 26, 31, 243, 137, 52, 47, 44, 189, 67, 5, 28, 234, 94, 239, 222,
      32, 175, 24, 3, 30, 214, 9, 87, 236, 235, 11, 188, 49, 17, 242, 36, 8, 150, 153, 232,
      93, 252, 60, 53, 0, 102, 41, 113, 198, 244, 35, 17, 186, 71, 98, 175, 193, 171, 13,
      34,164, 74, 185, 32, 132]);
    });

    test('could using tacit knowledge derivation', () async {
      await greatwallProtocol.startDerivation();
      greatwallProtocol.makeTacitDerivation(choiceNumber: 0);
      expect(greatwallProtocol.currentNode.value, [167, 249, 103, 124, 188, 123, 51, 168, 247,
      61, 208, 84, 232, 40, 39, 6, 1, 241, 91, 103, 231, 157, 236, 101, 146, 108, 180, 102, 54,
      232, 180, 175, 80, 139, 99, 120, 219, 3, 29, 254, 254, 160, 164, 115, 230, 195, 33, 223,
      43, 236, 123, 37, 100, 5, 105, 1, 113, 57, 117, 51, 53, 112, 36, 197, 219, 166, 15, 101,
      26, 31, 243, 137, 52, 47, 44, 189, 67, 5, 28, 234, 94, 239, 222, 32, 175, 24, 3, 30, 214,
      9, 87, 236, 235, 11, 188, 49, 17, 242, 36, 8, 150, 153, 232, 93, 252, 60, 53, 0, 102, 41,
      113, 198, 244, 35, 17, 186, 71, 98, 175, 193, 171, 13, 34, 164, 74, 185, 32, 132]);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 1);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 2);
      greatwallProtocol.makeTacitDerivation(choiceNumber: 3);

      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isTrue);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
    });

    test('flow could cancel the current running derivation', () async {
      await greatwallProtocol.startDerivation();
      greatwallProtocol.makeTacitDerivation(choiceNumber: 0);
      greatwallProtocol.cancelDerivation();

      expect(greatwallProtocol.isCanceled, isTrue);
      expect(greatwallProtocol.isStarted, isFalse);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
      expect(greatwallProtocol.derivationHashResult, isNull);
    });

    test('flow could be finish derivation successfully', () async {
      await greatwallProtocol.startDerivation();
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

    test('flow could handle finish incomplete derivation', () async {
      await greatwallProtocol.startDerivation();
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
