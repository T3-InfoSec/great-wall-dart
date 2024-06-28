import 'package:great_wall/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group of utils tests', () {
    late DerivationPath derivationPath;

    setUp(() {
      derivationPath = DerivationPath(nodesList: [1, 2, 3]);
    });

    test('Constructor', () {
      DerivationPath derivationPath1 = DerivationPath(nodesList: [1, 2, 3]);
      expect(derivationPath, derivationPath1);
    });

    test('Length', () {
      int derivationPathLength = derivationPath.length;
      expect(derivationPathLength, 3);
    });

    test('Add node to path', () {
      derivationPath.add(4);
      expect(derivationPath, [1, 2, 3, 4]);
    });

    test('First DerivationPath creation', () {
      derivationPath.pop();
      expect(derivationPath, [1, 2]);
    });

    test('First DerivationPath creation', () {
      derivationPath.clear();
      expect(derivationPath, <int>[]);
    });
  });
}
