<!--
This README describes the our package. If we publish this package to pub.dev,
this README's contents appear on the landing page for our package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Great-Wall Protocol
A Dart Implementation of a protocol that provides Kerckhoffian, 0-trust and
deviceless coercion-resistance in self-custody.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

A minimal `GreatWall` protocol setting to drive a hash from using tacit
knowledge. You can find more examples in `/example` folder.

```dart
import 'package:great_wall/great_wall.dart';

void main() {
  GreatWall greatwallProtocol = GreatWall(
    treeArity: 3,
    treeDepth: 1,
    timeLockPuzzleParam: 10,
  );

  // Start the protocol derivation process.
  greatwallProtocol.startDerivation();

  print(greatwallProtocol.currentLevelKnowledgePalettes);
  greatwallProtocol.makeTacitDerivation(
    choiceNumber: 1,
  ); // Choose the first palette
  print(greatwallProtocol.currentLevelKnowledgePalettes);

  // Finish the protocol derivation process.
  greatwallProtocol.finishDerivation();

  // Get the hash result of derivation.
  print('The derivation key is: ${greatwallProtocol.derivationHashResult}');
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
