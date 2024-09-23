import 'package:great_wall/great_wall.dart';
import 'package:great_wall/src/tacit_knowledge_impl.dart';
import 'package:t3_formosa/formosa.dart';

Future<void> main() async {
  GreatWall greatwallProtocol = GreatWall(
    treeArity: 3,
    treeDepth: 5,
    timeLockPuzzleParam: 1000,
    tacitKnowledgeType: TacitKnowledgeTypes.formosa,
    tacitKnowledgeConfigs: {'formosaTheme': FormosaTheme.bip39},
  );

  // Call the following if you need to explicitly re-initializing the protocol
  // derivation process.
  greatwallProtocol.initialDerivation();

  greatwallProtocol.seed0 =
      'viboniboasmofiasbrchsprorirerugugucavehistmiinciwibowifltuor';

  // Start the protocol derivation process.
  await greatwallProtocol.startDerivation(
        onProgress: (int progress) {
      // Logs each time progress changes
      print("Derivation in progress [$progress %]");
    },
  );

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
