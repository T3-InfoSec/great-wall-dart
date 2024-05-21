<!-- PROJECT LOGO -->
<p align="center">
  <a href="https://github.com/Yuri-SVB/Great_Wall">
	<img alt="Great Wall Logo" src="images/logo_big.jpg" height="160" />
  </a>
  <h3 align="center">GreatWall</h3>
  <p align="center">Protocol and application for providing Kerckhoffian, 0-trust, deviceless coercion-resistance in self-custody. For details, see <a href="index.md">docs</a>. To understand the protocol, refer to the <a href="white_paper_executive_summary/white_paper_executive_summary.md">white paper and executive summary</a>.
  </p>
   
  <p align="center">
    <a href="../LICENSE"><img alt="Software License" src="https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat-square&logo=appveyor"></a>
    <a href="docs/"><img alt="docs" src="https://img.shields.io/badge/Docs-read%20docs-brightgreen.svg?style=flat-square&logo=appveyor"></a>
    <a href="https://www.python.org/"><img alt="python3" src="https://img.shields.io/badge/Python-8+-brightgreen.svg?style=flat-square&logo=appveyor"></a>
    <a href=""><img alt="Maintainer" src="https://img.shields.io/badge/Maintainer-Yuri_S_Villas_Boas-bridghtgreen.svg?style=flat-square&logo=appveyor"></a>
  </p>
</p>


<!-- TABLE OF CONTENTS -->
## Table of Contents
1. [About](#about)
2. [Demo](#demo)
3. [Installation](#installation)
4. [Usage](#using-in-beta)
5. [Contact Us](#contact-us)
6. [Contributing](#contributing)


<!-- About -->
## About
Protocol and application for providing Kerckhoffian, 0-trust, deviceless coercion-resistance in self-custody. To understand the protocol, refer to the [white paper and executive summary.](./white_paper_executive_summary/white_paper_executive_summary.md)


<!-- Reproducing Demo 1 Experiment -->
## Demo
The following steps will allow an easy memorization of the path demonstrated in [demo 1](https://drive.proton.me/urls/GQZDRPBKE8#33ZVNJBXKAMd) within as little as 1-2 hours:
1. Download, install, and learn how to use [Anki](https://apps.ankiweb.net/) in your system;
2. Download (or clone from repository) and import [demo 1 Anki deck](demos/GW_procedural_memory_1.apkg);
3. Study deck;
4. Download (or clone from repository) [directory src](./src) **specifically in version** `e8b1551c08a3d59ee8cf30f2b5dfa803556a00a6`
5. In your system's terminal, open the directory, activate venv and then run main.py;
6. Enter `viboniboasmofiasbrchsprorirerugugucavehistmiinciwibowifltuor` as the required input `SA0`
7. You have, now, started to navigate the same tree as demonstrated in demo 1 from it's root. Continue as practiced with the aforementioned Anki deck until the leave.
8. By confirming with input 1 to the correct leave, you should get the following output: `53ffb290aa668cd5050e94aeecbb7046ce349d8ff775e409fcba45f6164a22d00e8cfb91e6836da62e7f7362cca30539b7f57f55e5c4a1cdf27a86997b99b2c6ee7760838ac0454e3e2f87714d303550b49063ff89934ecdb48e6c328f1c4561a9b7374232cdd8a71077653ca8091fc2b43b89f615ddac37aedfacd28bb605ba`. This is an **improper** BIP39 seed, _ie_ a seed that should **not** be used because it's trivially obtainable --- it or ways to obtain it have been published.
9. Just like the seed, all the addresses derived from it are **improper** and, therefore should not be used. One of them, obtained upon loading wallet with the seed in previous item, will be `bc1q3qjatkwlrxvkah0uphr2vj3lqqd73l22n7djl9`. In your favorite blockchain explorer, you can confirm that it's first two transactions were, respectively, receiving 198964 Sats, and then having them removed back (before publication). Obs.: in cases like that, it's advisable to utilize a coinjoin service to preserve privacy.


### Installation

To get started with `GreatWall`, ensure you have [Flutter](https://flutter.dev/docs/get-started/install) and [Dart](https://dart.dev/get-dart) installed on your machine.

Once you have Flutter and Dart set up, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/T3-InfoSec/great-wall-dart.git
   ```
2. Change directory to this GitHub repo:
   ```bash
   cd great-wall-dart
   ```
3. Install dependencies:
    ```bash
   flutter pub get
   ```
4. Run locally:
    ```bash
   flutter run
   ```
   Note: If you're using an emulator, start it before running the flutter run command. If you're running on a physical device, make sure it is connected to your machine.

### Using in Beta
Coming soon. An advanced, knowledgeable, tech-savvy reader, will, at this point, have understood what is to come and can improvise the steps by themselves. In a nutshell, all you have to do is to securely manage[^1] a brute-force resistant `SA0`, true-randomly generate a path vector of `L_i`'s, and memorize them procedurally as explained in the session above. For better effect, user can implement non-trivial **T**ime-**L**ock **P**uzzle, to impose desired time on derivation of `SA3` from `SA0`. To prevent leakage of critical content through Anki, a simple scheme with salt and pepper can be done so to avoid the need to modify Anki, but we'll leave this for a next time.

[^1]: That is, either memorize it, or deterministically derive it from other brute-force resistant secret information, or symmetrically encrypt it with a master key falling back in one of 2 previous cases and manage well the encrypted database.


<!-- Contact Us -->
## Contact Us
Coming soon...

We encourage and foster a welcoming and respectful community as we describe in our [code of conduct](./.github/CODE_OF_CONDUCT.md). This is our Pledge to anyone need to be one of our community.


<!-- Contributing -->
## Contributing
If you'd like to contribute to `GreatWall - Dart` development, please read first our [contributing guide](./.github/CONTRIBUTING.md).

If you experience problems with `GreatWall - Dart`, you can contribute by [log them on GitHub](https://github.com/T3-InfoSec/great-wall-dart/issues). If you want to contribute in code, please fork the code and submit a [pull request](https://github.com/T3-InfoSec/great-wall-dart/pulls) in new branch.
