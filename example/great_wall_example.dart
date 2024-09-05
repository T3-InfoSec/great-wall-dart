import 'package:great_wall/great_wall.dart';

void main() {
  GreatWall greatwallProtocol = GreatWall(
    treeArity: 3,
    treeDepth: 5,
    timeLockPuzzleParam: 10,
  );

  // Call the following if you need to explicitly re-initializing the protocol
  // derivation process.
  greatwallProtocol.initialDerivation();

  greatwallProtocol.seed0 =
      'viboniboasmofiasbrchsprorirerugugucavehistmiinciwibowifltuor';

  // Start the protocol derivation process.
  greatwallProtocol.startDerivation();

  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.makeTacitDerivation(
    choiceNumber: 1,
  ); // Choose the first palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.makeTacitDerivation(
    choiceNumber: 2,
  ); // Choose the second palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.makeTacitDerivation(
    choiceNumber: 3,
  ); // Choose the third palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.makeTacitDerivation(
    choiceNumber: 1,
  ); // Choose the first palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.makeTacitDerivation(
    choiceNumber: 2,
  ); // Choose the second palette

  // Finish the protocol derivation process.
  greatwallProtocol.finishDerivation();

  // Get the hash result of derivation.
  print('The derivation key is: ${greatwallProtocol.derivationHashResult}');
}
