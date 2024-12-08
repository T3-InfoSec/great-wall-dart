import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_formosa/formosa.dart';

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

  // Call the following if you need to explicitly re-initializing the protocol
  // derivation process.
  greatwallProtocolWithFormosa.initialDerivation();
  greatwallProtocolWithHashViz.initialDerivation();

  greatwallProtocolWithFormosa.sa0 = Sa0(Formosa(Entropy.fromRandom(wordsNumber: 6).value, FormosaTheme.bip39));

  // Start the protocol derivation process.
  greatwallProtocolWithFormosa.startDerivation();

  print(greatwallProtocolWithFormosa.currentLevelKnowledgePalettes);
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choiceNumber: 1,
  ); // Choose the first palette
  print(greatwallProtocolWithFormosa.currentLevelKnowledgePalettes);
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choiceNumber: 2,
  ); // Choose the second palette
  print(greatwallProtocolWithFormosa.currentLevelKnowledgePalettes);
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choiceNumber: 3,
  ); // Choose the third palette
  print(greatwallProtocolWithFormosa.currentLevelKnowledgePalettes);
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choiceNumber: 1,
  ); // Choose the first palette
  print(greatwallProtocolWithFormosa.currentLevelKnowledgePalettes);
  greatwallProtocolWithFormosa.makeTacitDerivation(
    choiceNumber: 2,
  ); // Choose the second palette

  // Finish the protocol derivation process.
  greatwallProtocolWithFormosa.finishDerivation();

  // Get the hash result of derivation.
  print(
    'The derivation key is: '
    '${greatwallProtocolWithFormosa.derivationHashResult}',
  );
}
