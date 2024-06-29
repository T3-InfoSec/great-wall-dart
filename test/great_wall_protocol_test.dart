import 'dart:typed_data';

import 'package:great_wall/src/great_wall_protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Tacit knowledge params tests', () {
    late GreatWall greatwallProtocol;

    setUp(() {
      greatwallProtocol = GreatWall(
        treeArity: 3,
        treeDepth: 5,
        timeLockPuzzleParam: 10,
      );
    });

    test('Constructor', () {
      expect(greatwallProtocol.treeDepth, 5);
      expect(greatwallProtocol.treeArity, 3);
      expect(greatwallProtocol.timeLockPuzzleParam, 10);
      expect(greatwallProtocol.derivationLevel, 0);
      expect(greatwallProtocol.hashResult, 0);
      expect(greatwallProtocol.isCanceled, isFalse);
      expect(greatwallProtocol.isStarted, isFalse);
      expect(greatwallProtocol.isFinished, isFalse);
      expect(greatwallProtocol.isInitialized, isTrue);
    });
  });
}
