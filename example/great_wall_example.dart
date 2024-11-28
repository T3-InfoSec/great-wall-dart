import 'package:great_wall/great_wall.dart';
import 'package:t3_formosa/formosa.dart';

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
    'xMin': 2.0,
    'xMax': 4.0,
    'yMin': -2.0,
    'yMax': 2.0,
    'realP': 0.5,
    'imaginaryParam': 0.5,
    'width': 800,
    'height': 600,
    'escapeRadius': 16,
    'maxIterations': 1000
  };
  GreatWall greatwallProtocolWithFractal = GreatWall(
    treeArity: 3,
    treeDepth: 4,
    timeLockPuzzleParam: 1,
    tacitKnowledge: FractalTacitKnowledge(configs: fractalConfigs),
  );

  var protocols = List.of([
    greatwallProtocolWithFormosa, 
    // greatwallProtocolWithHashViz, 
    // greatwallProtocolWithFractal
    ]);
  for (var protocol in protocols) {
    // Call the following if you need to explicitly re-initializing the protocol
    // derivation process.
    protocol.initialDerivation();

    protocol.seed0 =
      'viboniboasmofiasbrchsprorirerugugucavehistmiinciwibowifltuor';

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
