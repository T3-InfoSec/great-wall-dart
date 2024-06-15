// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:typed_data';

import 'utils.dart';
import 'knowledges.dart';

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
  int tlpParam = 0;

  String? _derivationKnowledgeType;
  final DerivationPath _derivationPath = DerivationPath();
  final Map<DerivationPath, List<int>> _savedDerivationStates = {};
  final Map<DerivationPath, List<dynamic>> _savedPathKnowledge = {};

  final List<MemoCard> _memoCards = [];

  // Palettes
  Mnemonic formosa = Mnemonic();
  Fractal fractal = Fractal();

  // Protocol parameters declaration
  late Uint8List seed0;
  late Uint8List seed1;
  late Uint8List seed2;
  late Uint8List seed3;
  late Uint8List currentState;
  late int currentLevel;
  late List<int> _shuffledArityIndices;

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
    _shuffledArityIndices = <int>[];
  }

  bool setThemedMnemonic(String theme) {
    try {
      formosa.expandPassword(theme.split('\n')[0]);
      return true;
    } on Exception catch (e) {
      // Handle error appropriately (e.g., print message)
      return false;
    }
  }

  void setFractalFunctionType(String funcType) {
    fractal.funcType = funcType;
  }

  void setTlpParam(int iterNum) {
    // Consider input validation for iterNum
    tlpParam = iterNum;
  }

  void setDepth(int depth) {
    // Consider input validation for depth
    treeDepth = depth;
  }

  void setArity(int arity) {
    // Consider input validation for arity
    treeArity = arity;
  }

  bool setSa0(String mnemonic) {
    isCanceled = false;
    try {
      initProtocolValues();
      currentState = Uint8List.fromList(mnemonic.codeUnits);
      return true;
    } on Exception catch (e) {
      // Handle error appropriately (e.g., print message)
      print(e);
      return false;
    }
  }

  void initializeDerivationHash() {}
  void updateWithQuickHash() {}
  void updateWithLongHash() {}

  void deriveHashInIntensiveTime() {
    print("Initializing SA0");
    currentState = seed0;
    if (isCanceled) {
      print("Task canceled");
      return;  // Exit the task if canceled
    }
    print("Deriving SA0 -> SA1");
    updateWithQuickHash();
    seed1 = currentState;
    if (isCanceled) {
      print("Task canceled");
      return;  // Exit the task if canceled
    }
    print("Deriving SA1 -> SA2");
    updateWithLongHash();
    seed2 = currentState;
    currentState = Uint8List.fromList(seed0 + currentState);
    if (isCanceled) {
      print("Task canceled");
      return;  // Exit the task if canceled
    }
    print("Deriving SA2 -> SA3");
    updateWithQuickHash();
    seed3 = currentState;

    _savedDerivationStates[_derivationPath] = currentState;
}
