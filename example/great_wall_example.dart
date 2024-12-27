import 'dart:math';

import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

void main() {
  Map<String, dynamic> formosaConfigs = {'formosaTheme': FormosaTheme.bip39};
  GreatWall greatwallProtocolWithFormosa = GreatWall(
    treeArity: 3,
    treeDepth: 4,
    timeLockPuzzleParam: 1,
    tacitKnowledge: FormosaTacitKnowledge(configs: formosaConfigs),
  );

  Map<String, dynamic> hashvizConfigs = {'hashvizSize': 16};

  GreatWall greatwallProtocolWithHashViz = GreatWall(
    treeArity: 3,
    treeDepth: 4,
    timeLockPuzzleParam: 1,
    tacitKnowledge: HashVizTacitKnowledge(configs: hashvizConfigs),
  );

  Map<String, dynamic> fractalConfigs = {
    'funcType': 'burningship',
    'xMin': -2.5,
    'xMax': 2.0,
    'yMin': -2.0,
    'yMax': 0.8,
    'realP': 2.0,
    'imagP': 0.0,
    'width': 1024,
    'height': 1024,
    'escapeRadius': 4,
    'maxIters': 30,
  };

  GreatWall greatwallProtocolWithFractal = GreatWall(
    treeArity: 3,
    treeDepth: 4,
    timeLockPuzzleParam: 1,
    tacitKnowledge: FractalTacitKnowledge(configs: fractalConfigs),
  );

  Map<String, dynamic> animatedFractalConfigs = {
    'funcType': 'burningship',
    'xMin': -2.5,
    'xMax': 2.0,
    'yMin': -2.0,
    'yMax': 0.8,
    'realP': 2.0,
    'imagP': 0.0,
    'width': 500,
    'height': 500,
    'escapeRadius': 4,
    'maxIters': 30,
    'n': 30,
    'A': 0.25,
    'B': 0.25,
    'phaseOffset': pi / 4,
    'frequencyK': 1,
    'frequencyL': 1
  };

  GreatWall greatwallProtocolWithAnimatedFractal = GreatWall(
    treeArity: 3,
    treeDepth: 4,
    timeLockPuzzleParam: 1,
    tacitKnowledge:
        AnimatedFractalTacitKnowledge(configs: animatedFractalConfigs),
  );

  var protocols = List.of([
    // greatwallProtocolWithFormosa,
    // greatwallProtocolWithHashViz,
    // greatwallProtocolWithFractal,
    greatwallProtocolWithAnimatedFractal
  ]);
  for (var protocol in protocols) {
    // Call the following if you need to explicitly re-initializing the protocol
    // derivation process.
    protocol.initialDerivation();

    protocol.sa0 = Sa0(Formosa.fromRandomWords(
        wordCount: 6, formosaTheme: FormosaTheme.bip39));

    // Start the protocol derivation process.
    protocol.startDerivation();

    print("Derivation level ${protocol.derivationLevel}");
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 1,
    );

    print("Derivation level ${protocol.derivationLevel}");
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 2,
    );

    print("Derivation level ${protocol.derivationLevel}");
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 3,
    );

    print("Derivation level ${protocol.derivationLevel}");
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 1,
    );

    // Finish the protocol derivation process.
    protocol.finishDerivation();

    // Get the hash result of derivation.
    print(
      'The derivation key is: '
      '${protocol.derivationHashResult}',
    );
  }
}
