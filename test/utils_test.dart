import 'dart:typed_data';

import 'package:great_wall/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('DerivationPath()', () {
    late DerivationPath derivationPath;
    late DerivationPath emptyDerivationPath;
    List<Choice> nodesList = [];

    setUp(() {
      for (int i = 0; i < 4; i++) {
        nodesList.add(Choice(Uint8List(i + 1)));
      }
      derivationPath =
          DerivationPath(nodesList: [nodesList[0], nodesList[1], nodesList[2]]);
      emptyDerivationPath = DerivationPath();
    });

    test('could use constructor', () {
      expect(derivationPath.isEmpty, isFalse);
      expect(emptyDerivationPath.isEmpty, isTrue);
      expect(derivationPath.first, nodesList[0]);
      expect(derivationPath.last, nodesList[2]);
      expect(derivationPath[0], nodesList[0]);
      expect(derivationPath[1], nodesList[1]);
      expect(derivationPath[2], nodesList[2]);
    });

    test('could get its length', () {
      int derivationPathLength = derivationPath.length;
      int emptyDerivationPathLength = emptyDerivationPath.length;
      expect(derivationPathLength, 3);
      expect(emptyDerivationPathLength, 0);
    });

    test('could add node path to its path', () {
      derivationPath.add(nodesList[3]);
      expect(derivationPath,
          [nodesList[0], nodesList[1], nodesList[2], nodesList[3]]);
    });

    test('could pop last node path from its path', () {
      derivationPath.pop();
      emptyDerivationPath.pop();
      expect(derivationPath, [nodesList[0], nodesList[1]]);
      expect(emptyDerivationPath, []);
    });

    test('could clear all nodes in path', () {
      derivationPath.clear();
      emptyDerivationPath.clear();
      expect(derivationPath, <int>[]);
      expect(emptyDerivationPath, <int>[]);
    });

    test('could equal another paths with same value nodes', () {
      DerivationPath newDerivationPath =
          DerivationPath(nodesList: [nodesList[0], nodesList[1]]);
      DerivationPath sameDerivationPath =
          DerivationPath(nodesList: [nodesList[0], nodesList[1], nodesList[2]]);

      expect(newDerivationPath, isA<DerivationPath>());
      expect(sameDerivationPath, isA<DerivationPath>());

      expect(derivationPath, isNot(newDerivationPath));
      expect(derivationPath, sameDerivationPath);
    });

    test('could create new path copy of its path', () {
      DerivationPath newDerivationPath = derivationPath.copy();
      expect(newDerivationPath, isA<DerivationPath>());
      expect(newDerivationPath, isNot(same(derivationPath)));
      expect(newDerivationPath, derivationPath);
    });
  });
}
