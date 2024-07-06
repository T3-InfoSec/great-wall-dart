import 'package:great_wall/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('DerivationPath', () {
    late DerivationPath derivationPath;
    late DerivationPath emptyDerivationPath;

    setUp(() {
      derivationPath = DerivationPath(nodesList: [1, 2, 3]);
      emptyDerivationPath = DerivationPath();
    });

    test('could use constructor', () {
      expect(derivationPath.isEmpty, isFalse);
      expect(emptyDerivationPath.isEmpty, isTrue);
      expect(derivationPath.first, 1);
      expect(derivationPath.last, 3);
      expect(derivationPath[0], 1);
      expect(derivationPath[1], 2);
      expect(derivationPath[2], 3);
    });

    test('could get its length', () {
      int derivationPathLength = derivationPath.length;
      int emptyDerivationPathLength = emptyDerivationPath.length;
      expect(derivationPathLength, 3);
      expect(emptyDerivationPathLength, 0);
    });

    test('could add node path to its path', () {
      derivationPath.add(4);
      expect(derivationPath, [1, 2, 3, 4]);
    });

    test('could pop last node path from its path', () {
      derivationPath.pop();
      emptyDerivationPath.pop();
      expect(derivationPath, [1, 2]);
      expect(emptyDerivationPath, []);
    });

    test('could clear all nodes in path', () {
      derivationPath.clear();
      emptyDerivationPath.clear();
      expect(derivationPath, <int>[]);
      expect(emptyDerivationPath, <int>[]);
    });

    test('could equal another paths with same value nodes', () {
      DerivationPath newDerivationPath = DerivationPath(nodesList: [1, 2]);
      DerivationPath sameDerivationPath = DerivationPath(nodesList: [1, 2, 3]);

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
