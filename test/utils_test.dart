import 'package:great_wall/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('utils tests', () {
    late DerivationPath derivationPath;
    late DerivationPath emptyDerivationPath;

    setUp(() {
      derivationPath = DerivationPath(nodesList: [1, 2, 3]);
      emptyDerivationPath = DerivationPath();
    });

    test('Constructor', () {
      expect(derivationPath.isEmpty, isFalse);
      expect(emptyDerivationPath.isEmpty, isTrue);
      expect(derivationPath.first, 1);
      expect(derivationPath.last, 3);
      expect(derivationPath[0], 1);
      expect(derivationPath[1], 2);
      expect(derivationPath[2], 3);
    });

    test('Length', () {
      int derivationPathLength = derivationPath.length;
      int emptyDerivationPathLength = emptyDerivationPath.length;
      expect(derivationPathLength, 3);
      expect(emptyDerivationPathLength, 0);
    });

    test('Add node to path', () {
      derivationPath.add(4);
      expect(derivationPath, [1, 2, 3, 4]);
    });

    test('Pop node from path', () {
      derivationPath.pop();
      emptyDerivationPath.pop();
      expect(derivationPath, [1, 2]);
      expect(emptyDerivationPath, []);
    });

    test('Clear nodes from path', () {
      derivationPath.clear();
      emptyDerivationPath.clear();
      expect(derivationPath, <int>[]);
      expect(emptyDerivationPath, <int>[]);
    });

    test('Equality of 2 paths', () {
      DerivationPath newDerivationPath = DerivationPath(nodesList: [1, 2]);
      DerivationPath sameDerivationPath = DerivationPath(nodesList: [1, 2, 3]);

      expect(newDerivationPath, isA<DerivationPath>());
      expect(sameDerivationPath, isA<DerivationPath>());

      expect(derivationPath, isNot(newDerivationPath));
      expect(derivationPath, sameDerivationPath);
    });

    test('Create new copy', () {
      DerivationPath newDerivationPath = derivationPath.copy();
      expect(newDerivationPath, isA<DerivationPath>());
      expect(newDerivationPath, isNot(same(derivationPath)));
      expect(newDerivationPath, derivationPath);
    });
  });
}
