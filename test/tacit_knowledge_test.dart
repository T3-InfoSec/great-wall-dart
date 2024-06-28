import 'dart:typed_data';

import 'package:great_wall/src/tacit_knowledge.dart';
import 'package:great_wall/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tacit knowledge params tests', () {
    late FormosaTacitKnowledgeParam formosaTacitKnowledgeParam;
    late FractalTacitKnowledgeParam fractalTacitKnowledgeParam;
    // late HashVizTacitKnowledgeParam hashvizTacitKnowledgeParam;

    setUp(() {
      formosaTacitKnowledgeParam = FormosaTacitKnowledgeParam(
        'arityIdx',
        Uint8List(128),
        Uint8List.fromList([0]),
      );

      fractalTacitKnowledgeParam = FractalTacitKnowledgeParam(
        "realParam",
        Uint8List(128),
        Uint8List.fromList([1, 2, 3, 4]),
      );
    });

    test('Constructor', () {
    });
  });

  group('Tacit knowledge tests', () {
    late FormosaTacitKnowledge formosaTacitKnowledge;
    late FractalTacitKnowledge fractalTacitKnowledge;
    // late HashVizTacitKnowledge hashvizTacitKnowledge;

    late DerivationPath derivationPath;

    setUp(() {
    });
  });
}
