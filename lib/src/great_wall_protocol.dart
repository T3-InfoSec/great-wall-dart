// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

import 'tacit_knowledge_impl.dart';
import 'utils.dart';

/// The core implementation of the [GreatWall] protocol.
///
/// [GreatWall] is an innovative protocol for providing Kerckhoffian, 0-trust
/// and deviceless coercion-resistance in self-custody. See the protocol white
/// paper for more details.
///
// TODO: Complete the library-level documentation comments.
class GreatWall {
  static final Uint8List argon2Salt = Uint8List(32);
  static final int bytesCount = 4;

  // Protocol helper parameters declaration
  late Uint8List _seed0;
  late Uint8List _seed1;
  late Uint8List _seed2;
  late Uint8List _seed3;
  late Uint8List _currentHash;
  late int _currentLevel;
  late List<int> _shuffledArityIndexes;
  late List<TacitKnowledge> _shuffledCurrentLevelKnowledgePalettes;

  final TacitKnowledge _tacitKnowledge = FormosaTacitKnowledge(
    {'theme': 'BiP39'},
    TacitKnowledgeParam(
      'formosaParam',
      Uint8List(128),
      Uint8List.fromList([]),
    ),
  );
  final DerivationPath _derivationPath = DerivationPath();
  final Map<DerivationPath, Uint8List> _savedDerivedStates = {};
  final Map<DerivationPath, List<TacitKnowledge>> _savedDerivedPathKnowledge = {};

  // Protocol control fields
  bool _isFinished = false;
  bool _isCanceled = false;
  bool _isInitialized = false;
  bool _isStarted = false;

  // Initializing parameters
  final int _treeArity;
  final int _treeDepth;
  final int _timeLockPuzzleParam;

  /// Create and initialize a [GreatWall] protocol instance.
  ///
  /// The [treeArity], [treeDepth] and [timeLockPuzzleParam] must be provided,
  /// they are used to properly and securely (by assigning them to large
  /// integers as you can) initializing the protocol and they must be positive
  /// integers if not only the absolute value of them will be considered.
  /// [treeArity] refers to the number of artiy in each branch, [treeDepth]
  /// refers to the number of branches that will be used in the derivation
  /// process and [timeLockPuzzleParam] refers to the hardness measure in the
  /// hard memory hashing process; big number means it's harder.
  GreatWall({
    required int treeArity,
    required int treeDepth,
    required int timeLockPuzzleParam,
  })  : _treeArity = treeArity.abs(),
        _treeDepth = treeDepth.abs(),
        _timeLockPuzzleParam = timeLockPuzzleParam.abs() {
    initialDerivation();
  }

  /// Get the current hash state of the protocol derivation process.
  Uint8List get currentHash => _currentHash;

  /// Get the tacit knowledge palettes of current level.
  List<TacitKnowledge> get currentLevelKnowledgePalettes =>
      _shuffledCurrentLevelKnowledgePalettes;

  /// Get the result of the protocol derivation process.
  ///
  /// The result requires calling [finishDerivation] first.
  Uint8List? get derivationHashResult => (isFinished) ? _currentHash : null;

  /// Get the current level of the protocol derivation process.
  int get derivationLevel => _currentLevel;

  /// The tacit knowledge that will be used in the protocol hash derivation
  /// process.
  TacitKnowledge get derivationTacitKnowledge => _tacitKnowledge;

  set derivationTacitKnowledge(TacitKnowledge tacitKnowledge) {
    tacitKnowledge = tacitKnowledge;
  }

  /// Check if the protocol derivation process canceled.
  bool get isCanceled => _isCanceled;

  /// Check if the protocol derivation process finished normally.
  bool get isFinished => _isFinished;

  /// Check if the protocol derivation process has been initialized
  /// completely and correctly or not.
  bool get isInitialized => _isInitialized;

  /// Check if the protocol derivation process started correctly.
  bool get isStarted => _isStarted;

  /// Set the value of the [password] that you need to hash it by using
  /// [GreatWall] protocol.
  // TODO: Make sure the password match one of the formosa theme.
  set seed0(String password) {
    initialDerivation();
    _currentHash = _seed0 = Uint8List.fromList(password.codeUnits);
  }

  /// Get the param of the memory hard hashing process.
  int get timeLockPuzzleParam => _timeLockPuzzleParam;

  /// Get the tree arity of the derivation process.
  int get treeArity => _treeArity;

  /// Get the tree depth of the derivation process.
  int get treeDepth => _treeDepth;

  /// Cancel the current running derivation process.
  // TODO: Add documentation comments.
  void cancelDerivation() {
    if (isStarted) {
      _isStarted = false;
      _isCanceled = true;
    } else {
      print('The derivation is not running currently.');
      _isCanceled = false;
    }
  }

  /// Finish the protocol derivation process.
  ///
  /// You need to fill the protocol requirements to be able to finish the
  /// derivation process. If the requirements not fill properly the finishing
  /// process will be aborted with a message indicating that.
  ///
  /// We provide the requirement of manual finishing to add a support for
  /// finishing without satisfying optional protocol requirements.
  ///
  /// The finishing requirements are that the protocol is correctly started
  /// and initialized and the required steps of tacit derivation are filled.
  void finishDerivation() {
    if (isStarted && isInitialized && _currentLevel == treeDepth + 1) {
      TacitKnowledge tacitKnowledge = derivationTacitKnowledge;

      switch (tacitKnowledge) {
        case FormosaTacitKnowledge():
          DerivationPath tempPath = DerivationPath();
          List<TacitKnowledge> chosenKnowledgeList = [];
          for (int node in _derivationPath) {
            List<TacitKnowledge> levelKnowledgeList =
                _savedDerivedPathKnowledge[tempPath]!;
            TacitKnowledge chosenKnowledge = levelKnowledgeList[node - 1];
            chosenKnowledgeList.add(chosenKnowledge);
            tempPath.add(node);
          }
        case FractalTacitKnowledge():
          DerivationPath tempPath = DerivationPath();
          List<TacitKnowledge> chosenKnowledgeList = [];
          for (int node in _derivationPath) {
            List<TacitKnowledge> levelKnowledgeList =
                _savedDerivedPathKnowledge[tempPath]!;
            TacitKnowledge chosenKnowledge = levelKnowledgeList[node - 1];
            chosenKnowledgeList.add(chosenKnowledge);
            tempPath.add(node);
          }
        // case HashVizTacitKnowledge():
        //   DerivationPath tempPath = DerivationPath();
        //   List<TacitKnowledge> chosenKnowledgeList = [];
        //   for (int node in _derivationPath) {
        //     TacitKnowledge chosenKnowledge =
        //         _savedDerivedPathKnowledge[tempPath]![node];
        //     chosenKnowledgeList.add(chosenKnowledge);
        //     tempPath.add(node);
        //   }
      }

      print('Key = $_currentHash');
      _isFinished = true;
    } else {
      print('Derivation does not started yet or not completed.');
      _isFinished = false;
    }
  }

  /// Reset the [GreatWall] protocol derivation process to its initial state.
  void initialDerivation() {
    _seed0 = Uint8List(128);
    _seed1 = Uint8List(128);
    _seed2 = Uint8List(128);
    _seed3 = Uint8List(128);
    _currentHash = _seed0;
    _currentLevel = 0;
    _shuffledArityIndexes = <int>[];
    _shuffledCurrentLevelKnowledgePalettes = <TacitKnowledge>[];

    derivationTacitKnowledge = FormosaTacitKnowledge(
      {'theme': 'BiP39'},
      TacitKnowledgeParam(
        'formosaParam',
        Uint8List(128),
        Uint8List.fromList([]),
      ),
    );
    _derivationPath.clear();
    _savedDerivedStates.clear();
    _savedDerivedPathKnowledge.clear();

    _isInitialized = true;
  }

  /// Drive the [GreatWall.currentHash] from the user choice [choiceNumber].
  ///
  /// If [choiceNumber] is 0, the protocol will go back one level to its
  /// previous state, if it is greater 0 the protocol will update the state
  /// depending on this choice.
  void makeTacitDerivation({required int choiceNumber}) {
    if (isStarted &&
        !isCanceled &&
        _savedDerivedPathKnowledge.containsKey(_derivationPath.copy())) {
      if (choiceNumber > 0) {
        _currentLevel += 1;
        _derivationPath.add(choiceNumber);

        if (_savedDerivedStates.containsKey(_derivationPath.copy())) {
          _currentHash = _savedDerivedStates[_derivationPath]!;
        } else {
          _currentHash = Uint8List.fromList(
            _currentHash + [_shuffledArityIndexes[choiceNumber - 1]],
          );
          _updateWithQuickHashing();
          _savedDerivedStates[_derivationPath.copy()] = _currentHash;
        }

        _generateLevelKnowledgePalettes();
      } else {
        _returnDerivationOneLevelBack();
        _generateLevelKnowledgePalettes();
      }
    } else {
      print(
        'Derivation does not started yet. Please, start the derivation'
        ' process first.',
      );
    }
  }

  // TODO: Add documentation comments.
  void startDerivation() {
    if (isInitialized) {
      _makeExplicitDerivation();
      _isStarted = true;
    } else {
      print('Derivation does not initialized yet.');
      _isStarted = false;
    }
  }

  // TODO: Add documentation comments.
  List<TacitKnowledge> _generateLevelKnowledgePalettes() {
    TacitKnowledge tacitKnowledge = derivationTacitKnowledge;

    if (_savedDerivedPathKnowledge.containsKey(_derivationPath.copy())) {
      _shuffledCurrentLevelKnowledgePalettes = _savedDerivedPathKnowledge[_derivationPath]!;
    } else {
      _shuffleArityIndexes();
      switch (tacitKnowledge) {
        case FormosaTacitKnowledge():
          List<FormosaTacitKnowledge> shuffledFormosaPalettes = [
            for (final arityIdx in _shuffledArityIndexes)
              FormosaTacitKnowledge(
                tacitKnowledge.configs,
                TacitKnowledgeParam(
                  'formosaParam',
                  _currentHash,
                  Uint8List.fromList([arityIdx]),
                ),
              )
          ];
          _savedDerivedPathKnowledge[_derivationPath.copy()] =
              shuffledFormosaPalettes;
          _shuffledCurrentLevelKnowledgePalettes = shuffledFormosaPalettes;
        case FractalTacitKnowledge():
          List<FractalTacitKnowledge> shuffledFractalPalettes = [
            for (final arityIdx in _shuffledArityIndexes)
              FractalTacitKnowledge(
                tacitKnowledge.configs,
                TacitKnowledgeParam(
                  'fractalParam',
                  _currentHash,
                  Uint8List.fromList([arityIdx]),
                ),
              )
          ];
          _savedDerivedPathKnowledge[_derivationPath.copy()] =
              shuffledFractalPalettes;
          _shuffledCurrentLevelKnowledgePalettes = shuffledFractalPalettes;
        // case HashVizTacitKnowledge():
        //   List<FractalTacitKnowledge> shuffledFractalPalettes = [];
        //   shuffledPalettes = shuffledFractalPalettes;
      }
    }
    return _shuffledCurrentLevelKnowledgePalettes;
  }

  // TODO: Add documentation comments.
  void _makeExplicitDerivation() {
    print('Deriving Seed0 -> Seed1');
    _updateWithQuickHashing();
    _seed1 = _currentHash;
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }
    print('Deriving Seed1 -> Seed2');
    _updateWithLongHashing();
    _seed2 = _currentHash;
    _currentHash = Uint8List.fromList(_seed0 + _currentHash);
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }
    print('Deriving Seed2 -> Seed3');
    _updateWithQuickHashing();
    _seed3 = _currentHash;

    _savedDerivedStates[_derivationPath.copy()] = _currentHash;

    // Prepare the level 1 of tacit derivation process.
    _currentLevel += 1;
    _generateLevelKnowledgePalettes();
  }

  /// Go back one level to the previous derivation state.
  void _returnDerivationOneLevelBack() {
    if (_currentLevel == 0 || _currentLevel == 1) return;

    if (_isFinished) _isFinished = false;

    _currentLevel -= 1;
    _derivationPath.pop();

    _currentHash = _savedDerivedStates[_derivationPath]!;
  }

  /// Fill and shuffles a list with numbers in range [GreatWall.treeArity].
  void _shuffleArityIndexes() {
    _shuffledArityIndexes = [for (var idx = 0; idx < treeArity; idx++) idx];

    _shuffledArityIndexes.shuffle(Random.secure());
  }

  /// Update the state with its hash taking presumably a long time.
  void _updateWithLongHashing() {
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: timeLockPuzzleParam,
      parallelism: 1,
      memorySizeKB: 1024 * 1024,
      salt: argon2Salt,
    );

    _currentHash = argon2Algorithm.convert(_currentHash).bytes;
  }

  /// Update the state with its hash taking presumably a quick time.
  void _updateWithQuickHashing() {
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: 1,
      parallelism: 1,
      memorySizeKB: 10 * 1024,
      salt: argon2Salt,
    );

    _currentHash = argon2Algorithm.convert(_currentHash).bytes;
  }
}
