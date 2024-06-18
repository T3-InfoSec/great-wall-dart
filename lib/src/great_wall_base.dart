// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

import 'knowledges.dart';
import 'utils.dart';

// TODO: Add comment documentations.
class GreatWall {
  static final Uint8List argon2Salt = Uint8List(32);
  static final int bytesCount = 4;

  // Protocol and derivation control fields
  bool isFinished = false;
  bool isCanceled = false;
  bool isInitialized = false;

  int treeDepth = 0;
  int treeArity = 0;
  int timeLockPuzzleParam = 0;

  String? _derivationKnowledgeType;
  final DerivationPath _derivationPath = DerivationPath();
  final Map<DerivationPath, Uint8List> _savedDerivationStates = {};
  final Map<DerivationPath, List<dynamic>> _savedPathKnowledge = {};

  final List<MemoCard> _memoCards = [];

  // Palettes
  Formosa formosa = Formosa();
  Fractal fractal = Fractal();

  // Protocol parameters declaration
  late Uint8List seed0;
  late Uint8List seed1;
  late Uint8List seed2;
  late Uint8List seed3;
  late Uint8List currentState;
  late int currentLevel;
  late List<int> _shuffledArityIndexes;

  GreatWall() {
    initProtocolValues();
  }

  void initProtocolValues() {
    seed0 = Uint8List(128);
    seed1 = seed0;
    seed2 = seed1;
    seed3 = seed2;
    currentState = seed3;
    currentLevel = 0;
    _shuffledArityIndexes = <int>[];
  }

  bool setThemedMnemonic(String theme) {
    try {
      formosa.expandPassword(theme.split('\n')[0]);
      return true;
    } on Exception catch (e) {
      // TODO: Handle error appropriately (e.g., print message)
      return false;
    }
  }

  void setFractalFunctionType(String funcType) {
    fractal.funcType = funcType;
  }

  void setTimeLockPuzzleParam(int iterNum) {
    // TODO: Consider input validation for iterNum
    timeLockPuzzleParam = iterNum;
  }

  void setDepth(int depth) {
    // TODO: Consider input validation for depth
    treeDepth = depth;
  }

  void setArity(int arity) {
    // TODO: Consider input validation for arity
    treeArity = arity;
  }

  bool setSeed0(String mnemonic) {
    isCanceled = false;
    try {
      initProtocolValues();
      currentState = Uint8List.fromList(mnemonic.codeUnits);
      return true;
    } on Exception catch (e) {
      // TODO: Handle error appropriately (e.g., print message)
      print(e);
      return false;
    }
  }

  void startHashDerivation() {
    currentState = seed0;
    currentLevel = 0;

    _derivationKnowledgeType = null;
    _derivationPath.clear();
    _savedDerivationStates.clear();
    _savedPathKnowledge.clear();

    // Actual work
    deriveHashInIntensiveTime();
    isInitialized = true;
  }

  /// Update the state with its hash taking presumably a long time.
  void updateWithLongHashing() {
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: 3,
      parallelism: 1,
      memorySizeKB: 1024*1024*1024,
      salt: argon2Salt,
    );

    currentState = argon2Algorithm.convert(currentState).bytes;
  }

  /// Update the state with its hash taking presumably a quick time.
  void updateWithQuickHashing() {
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: 3,
      parallelism: 1,
      memorySizeKB: 1024*1024,
      salt: argon2Salt,
    );

    currentState = argon2Algorithm.convert(currentState).bytes;
  }

  void deriveHashInIntensiveTime() {
    print("Initializing SA0");
    currentState = seed0;
    if (isCanceled) {
      print("Task canceled");
      return;
    }
    print("Deriving SA0 -> SA1");
    updateWithQuickHashing();
    seed1 = currentState;
    if (isCanceled) {
      print("Task canceled");
      return;
    }
    print("Deriving SA1 -> SA2");
    updateWithLongHashing();
    seed2 = currentState;
    currentState = Uint8List.fromList(seed0 + currentState);
    if (isCanceled) {
      print("Task canceled");
      return;
    }
    print("Deriving SA2 -> SA3");
    updateWithQuickHashing();
    seed3 = currentState;

    _savedDerivationStates[_derivationPath] = currentState;
  }

  /// Fill and shuffles a list of numbers in range [GreatWall.treeArity].
  void _shuffleArityIndexes() {
    _shuffledArityIndexes = [for (var idx = 0; idx <= treeArity; idx++) idx];

    _shuffledArityIndexes.shuffle(Random.secure());
  }

  /// Drive the protocol state from the user choice index.
  ///
  /// If [idx] is 0, the protocol will go back one level to its previous state,
  /// If it is greater 0 the protocol will update the state depending on this choice.
  void deriveFromUserChoice(int idx) {
    if (idx > 0) {
      currentLevel += 1;
      _derivationPath.add(idx);

      if (_savedDerivationStates.containsKey(_derivationPath)) {
        currentState = _savedDerivationStates[_derivationPath]!;
      } else {
        currentState.add(_shuffledArityIndexes[idx - 1]);
        updateWithQuickHashing();
        _savedDerivationStates[_derivationPath] = currentState;
      }

    } else {
      returnLevel();
    }
  }
}
