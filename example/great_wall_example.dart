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
    'xMin': 2,
    'xMax': 4,
    'yMin': -2,
    'yMax': 2,
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

  var protocols = List.of([greatwallProtocolWithFormosa, greatwallProtocolWithHashViz, greatwallProtocolWithFractal]);
  for (var protocol in protocols) {
    // Call the following if you need to explicitly re-initializing the protocol
    // derivation process.
    protocol.initialDerivation();

    protocol.seed0 =
      'viboniboasmofiasbrchsprorirerugugucavehistmiinciwibowifltuor';

    // Start the protocol derivation process.
    protocol.startDerivation();

    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print("Derivation level ${protocol.derivationLevel}");
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 1,
    ); // Choose the first palette
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 2,
    ); // Choose the second palette
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 3,
    ); // Choose the third palette
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 1,
    ); // Choose the first palette
    for (var tacitKnowledge in protocol.currentLevelKnowledgePalettes) {
      print(tacitKnowledge.knowledge);
    }
    protocol.makeTacitDerivation(
      choiceNumber: 2,
    ); // Choose the second palette

    // Finish the protocol derivation process.
    protocol.finishDerivation();

    // Get the hash result of derivation.
    print(
      'The derivation key is: '
      '${protocol.derivationHashResult}',
    );
  }
}
