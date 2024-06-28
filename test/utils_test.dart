import 'package:great_wall/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('utils tests', () {
    late DerivationPath derivationPath;

    setUp(() {
      derivationPath = DerivationPath(nodesList: [1, 2, 3]);
    });

    test('Constructor', () {
      expect(derivationPath.isEmpty, isFalse);
      expect(derivationPath.first, 1);
      expect(derivationPath.last, 3);
      expect(derivationPath[0], 1);
      expect(derivationPath[1], 2);
      expect(derivationPath[2], 3);
    });

    test('Length', () {
      int derivationPathLength = derivationPath.length;
      expect(derivationPathLength, 3);
    });

    test('Add node to path', () {
      derivationPath.add(4);
      expect(derivationPath, [1, 2, 3, 4]);
    });

    test('Pop node from path', () {
      derivationPath.pop();
      expect(derivationPath, [1, 2]);
    });

    test('Clear nodes from path', () {
      derivationPath.clear();
      expect(derivationPath, <int>[]);
    });
  });
}
