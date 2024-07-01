import 'dart:typed_data';

import 'package:great_wall/src/great_wall_protocol.dart';
import 'package:great_wall/src/tacit_knowledge.dart';
import 'package:test/test.dart';

void main() {
  group('GreatWall protocol tests', () {
    late GreatWall greatwallProtocol;

    late Map<String, dynamic> fractalExpectedConfigs;
    late Map<String, FractalTacitKnowledgeParam> fractalExpectedParams;
    late FractalTacitKnowledge fractalTacitKnowledge;

    setUp(() {
      greatwallProtocol = GreatWall(
        treeArity: 3,
        treeDepth: 5,
        timeLockPuzzleParam: 10,
      );
    });

    test('Constructor', () {
      expect(GreatWall.argon2Salt, Uint8List(32));
      expect(GreatWall.bytesCount, 4);

      expect(greatwallProtocol.treeArity, 3);
      expect(greatwallProtocol.treeDepth, 5);
      expect(greatwallProtocol.timeLockPuzzleParam, 10);
      expect(greatwallProtocol.derivationLevel, 0);
      expect(greatwallProtocol.derivationResult, Uint8List(128));
      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isFalse);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);

      expect(
        greatwallProtocol.derivationTacitKnowledge,
        isA<FormosaTacitKnowledge>(),
      );
    });
  });
}
