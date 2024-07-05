import 'package:great_wall/great_wall.dart';

void main() {
  GreatWall greatwallProtocol = GreatWall(
    treeArity: 3,
    treeDepth: 5,
    timeLockPuzzleParam: 10,
  );

  greatwallProtocol.startDerivation();

  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.tacitDerivation(
    choiceNumber: 1,
  ); // Choose the first palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.tacitDerivation(
    choiceNumber: 2,
  ); // Choose the second palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.tacitDerivation(
    choiceNumber: 3,
  ); // Choose the third palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.tacitDerivation(
    choiceNumber: 1,
  ); // Choose the first palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.tacitDerivation(
    choiceNumber: 2,
  ); // Choose the second palette

  greatwallProtocol.finishDerivation();
}
