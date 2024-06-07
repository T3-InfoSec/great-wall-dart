// Copyright (c) 2024, Yuri S Villas Boas.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'utils.dart';
import 'knowledges.dart';

/// This class manages cryptographic operations and protocol parameters.
class GreatWall {
  static final argon2Salt = Uint8List(32);
  static final int bytesCount = 4;

  bool isFinished = false;
  bool isCanceled = false;
  bool isInitialized = false;

  String? _derivationKnowledgeType;
  final DerivationPath _derivationPath = DerivationPath();
  final Map<DerivationPath, List<int>> _savedDerivationStates = {};
  final Map<DerivationPath, List<dynamic>> _savedPathKnowledge = {};

  final List<MemoCard> _memoCards = [];

  // Palettes
  Mnemonic mnemonic = Mnemonic();
  Fractal fractal = Fractal();

  // Initializing derivation parameters
  int treeDepth = 0;
  int treeArity = 0;
  int tlpParam = 0;

  // Initializing protocol parameters
  late Uint8List seed0;
  late Uint8List seed1;
  late Uint8List seed2;
  late Uint8List seed3;
  late Uint8List currentState;
  late int currentLevel;

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
  }

  bool setThemedMnemonic(String theme) {
    try {
      mnemonic.expandPassword(theme.split('\n')[0]);
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
      return false;
    }
  }
}
