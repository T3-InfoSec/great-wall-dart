import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

void main() {
  Map<String, dynamic> formosaConfigs = {'formosaTheme': FormosaTheme.bip39};
  GreatWall greatwallProtocolWithFormosa = GreatWall(
    treeArity: 3,
    treeDepth: 5,
    timeLockPuzzleParam: 10,
    tacitKnowledge: FormosaTacitKnowledge(configs: formosaConfigs),
  );

  Map<String, dynamic> hashvizConfigs = {'hashvizSize': 16};
  GreatWall greatwallProtocolWithHashViz = GreatWall(
    treeArity: 3,
    treeDepth: 5,
    timeLockPuzzleParam: 10,
    tacitKnowledge: HashVizTacitKnowledge(configs: hashvizConfigs),
  );

  Map<String, dynamic> dynamicFractalConfigs =
      {}; // Todo: Add dynamic fractal configs later
  GreatWall greatWallProtocolWithDynamicFractal = GreatWall(
    treeArity: -1,
    treeDepth:
        3, // Todo: Add dynamic fractal tree depth later depending on the user's choice
    timeLockPuzzleParam: 10,
    tacitKnowledge:
        DynamicFractalTacitKnowledge(configs: dynamicFractalConfigs),
  );

  // Call the following if you need to explicitly re-initializing the protocol
  // derivation process.
  // Todo: remove the following line if you don't need to re-initialize the protocol derivation process.
  greatwallProtocolWithFormosa.initialDerivation();
  greatwallProtocolWithHashViz.initialDerivation();
  greatWallProtocolWithDynamicFractal.initialDerivation();

  greatwallProtocolWithFormosa.sa0 = Sa0(
      Formosa.fromRandomWords(wordCount: 6, formosaTheme: FormosaTheme.bip39));

  // Start the protocol derivation process.
  greatwallProtocolWithFormosa.startDerivation();

  greatwallProtocolWithFormosa.makeTacitDerivation(
    choice: "1",
  ); // Choose the first palette
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choice: "2",
  ); // Choose the second palette
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choice: "3",
  ); // Choose the third palette
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choice: "1",
  ); // Choose the first palette
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choice: "2",
  ); // Choose the second palette

  // Finish the protocol derivation process.
  greatwallProtocolWithFormosa.finishDerivation();

  // Dynamic Fractal Flow

  greatWallProtocolWithDynamicFractal.sa0 = Sa0(Formosa.fromRandomWords(
      wordCount: 6,
      formosaTheme: FormosaTheme
          .bip39)); // Todo: replace the Sa0 with the actual Sa0 object

  // Start the protocol derivation process.
  greatWallProtocolWithDynamicFractal.startDerivation();
  greatWallProtocolWithDynamicFractal.makeTacitDerivation(
      choice: "x: 0.123456789, y: 0.987654321");
  greatWallProtocolWithDynamicFractal.makeTacitDerivation(
      choice: "x: 0.123411565, y: 0.98444534321");
  greatWallProtocolWithDynamicFractal.makeTacitDerivation(
      choice: "x: 0.1234519, y: 0.447654321");
  greatWallProtocolWithDynamicFractal.finishDerivation();

  // Get the hash result of derivation.
  print(
    'The derivation key is: '
    '${greatwallProtocolWithFormosa.derivationHashResult}',
  );

  print(
    'The derivation key is: '
    '${greatWallProtocolWithDynamicFractal.derivationHashResult}',
  );
}
