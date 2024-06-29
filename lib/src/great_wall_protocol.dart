// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

import 'tacit_knowledge.dart';
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

  // Protocol parameters declaration
  late Uint8List _seed0;
  late Uint8List _seed1;
  late Uint8List _seed2;
  late Uint8List _seed3;
  late Uint8List _currentState;
  late int _currentLevel;
  late List<int> _shuffledArityIndexes;

  // Protocol control fields
  bool _isFinished = false;
  bool _isCanceled = false;
  bool _isInitialized = false;
  bool _isStarted = false;

  int treeDepth = 0;
  int treeArity = 0;
  int timeLockPuzzleParam = 0;

  TacitKnowledge derivationTacitKnowledge = FormosaTacitKnowledge(
    {'theme': 'BiP39'},
    {
      'formosaParam': FormosaTacitKnowledgeParam(
        'formosaParam',
        Uint8List(128),
        Uint8List.fromList([]),
      )
    },
  );
  final DerivationPath _derivationPath = DerivationPath();
  final Map<DerivationPath, Uint8List> _savedDerivedStates = {};
  final Map<DerivationPath, List<TacitKnowledge>> _savedDerivedPathKnowledge = {};

  GreatWall() {
    initialProtocol();
  }

  /// Get the current level of the protocol derivation operation.
  int get derivationLevel => _currentLevel;

  /// Get the result of the protocol derivation operation.
  Uint8List get hashResult => _currentState;

  /// Check if the protocol derivation process canceled.
  bool get isCanceled => _isCanceled;

  /// Check if the protocol derivation process finished normally.
  bool get isFinished => _isFinished;

  /// Check if the initialization process of the protocol derivation has been
  /// completed correctly or not.
  bool get isInitialized => _isInitialized;

  /// Check if the protocol derivation process started correctly.
  bool get isStarted => _isStarted;

  /// Set the value of the [password] that you need to hash it by using
  /// [GreatWall] protocol.
  set seed0(String password) {
    initialProtocol();
    _currentState = _seed0 = Uint8List.fromList(password.codeUnits);
  }

  void cancelDerivation() {
    if (isStarted) {
      _isCanceled = true;
    } else {
      print('The derivation is not running currently.');
      _isCanceled = false;
    }
  }

  void finishDerivation() {
    if (isStarted) {
      TacitKnowledge tacitKnowledge = derivationTacitKnowledge;

      switch (tacitKnowledge) {
        case FormosaTacitKnowledge():
          DerivationPath tempPath = DerivationPath();
          List<TacitKnowledge> chosenKnowledgeList = [];
          for (int node in _derivationPath) {
            TacitKnowledge chosenKnowledge =
                _savedDerivedPathKnowledge[tempPath]![node];
            chosenKnowledgeList.add(chosenKnowledge);
            tempPath.add(node);
          }
        case FractalTacitKnowledge():
          DerivationPath tempPath = DerivationPath();
          List<TacitKnowledge> chosenKnowledgeList = [];
          for (int node in _derivationPath) {
            TacitKnowledge chosenKnowledge =
                _savedDerivedPathKnowledge[tempPath]![node];
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

      print('Key = ${_currentState.buffer}');
      _isFinished = true;
    } else {
      print('Derivation does not started yet.');
      _isFinished = false;
    }
  }

  List<TacitKnowledge> generateKnowledgePalettes() {
    TacitKnowledge tacitKnowledge = derivationTacitKnowledge;
    List<TacitKnowledge> shuffledPalettes;

    if (_savedDerivedPathKnowledge.containsKey(_derivationPath)) {
      shuffledPalettes = _savedDerivedPathKnowledge[_derivationPath]!;
    } else {
      _shuffleArityIndexes();
      switch (tacitKnowledge) {
        case FormosaTacitKnowledge():
          List<FormosaTacitKnowledge> shuffledFormosaPalettes = [
            for (final arityIdx in _shuffledArityIndexes)
              tacitKnowledge
                ..configs = {
                  'formosaParam': FormosaTacitKnowledgeParam(
                    'formosaParam',
                    _currentState,
                    Uint8List.fromList([arityIdx]),
                  )
                }
          ];
          shuffledPalettes = shuffledFormosaPalettes;
        case FractalTacitKnowledge():
          List<FractalTacitKnowledge> shuffledFractalPalettes = [
            for (final arityIdx in _shuffledArityIndexes)
              tacitKnowledge
                ..params = {
                  'realParam': FractalTacitKnowledgeParam(
                    'realParam',
                    _currentState,
                    Uint8List.fromList([arityIdx]),
                  ),
                  'imaginaryParam': FractalTacitKnowledgeParam(
                    'imaginaryParam',
                    _currentState,
                    Uint8List.fromList([arityIdx]),
                  )
                }
          ];
          shuffledPalettes = shuffledFractalPalettes;
        // case HashVizTacitKnowledge():
        //   List<FractalTacitKnowledge> shuffledFractalPalettes = [];
        //   shuffledPalettes = shuffledFractalPalettes;
      }
    }
    return shuffledPalettes;
  }

  /// Reset the [GreatWall] protocol and its attributes to its initial state.
  void initialProtocol() {
    _seed0 = Uint8List(128);
    _seed1 = Uint8List(128);
    _seed2 = Uint8List(128);
    _seed3 = Uint8List(128);
    _currentState = _seed0;

    _currentLevel = 0;
    _shuffledArityIndexes = <int>[];

    derivationTacitKnowledge = FormosaTacitKnowledge(
      {'theme': 'BiP39'},
      {
        'formosaParam': FormosaTacitKnowledgeParam(
          'formosaParam',
          Uint8List(128),
          Uint8List.fromList([]),
        )
      },
    );
    _derivationPath.clear();
    _savedDerivedStates.clear();
    _savedDerivedPathKnowledge.clear();

    _isInitialized = true;
  }

  /// Go back to the previous state hash.
  void returnLevel() {
    if (_currentLevel == 0) return;

    if (_isFinished) _isFinished = false;

    _currentLevel -= 1;
    _derivationPath.pop();

    _currentState = _savedDerivedStates[_derivationPath]!;
  }

  void startDerivation() {
    if (isInitialized) {
      _explicitDerivation();
      _isStarted = true;
    } else {
      print('Derivation does not initialized yet.');
      _isStarted = false;
    }
  }

  /// Drive the [GreatWall.hashResult] from the user choice [idx].
  ///
  /// If [idx] is 0, the protocol will go back one level to its previous state,
  /// If it is greater 0 the protocol will update the state depending on this choice.
  void tacitDerivation(int idx) {
    if (isStarted && !isCanceled) {
      if (idx > 0) {
        _currentLevel += 1;
        _derivationPath.add(idx);

        if (_savedDerivedStates.containsKey(_derivationPath)) {
          _currentState = _savedDerivedStates[_derivationPath]!;
        } else {
          _currentState.add(_shuffledArityIndexes[idx - 1]);
          _updateWithQuickHashing();
          _savedDerivedStates[_derivationPath] = _currentState;
        }

      } else {
        returnLevel();
      }
    } else {
      print(
        'Derivation does not started yet. Please, start the derivation'
        ' process first.',
      );
    }
  }

  void _explicitDerivation() {
    print('Deriving Seed0 -> Seed1');
    _updateWithQuickHashing();
    _seed1 = _currentState;
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }
    print('Deriving Seed1 -> Seed2');
    _updateWithLongHashing();
    _seed2 = _currentState;
    _currentState = Uint8List.fromList(_seed0 + _currentState);
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }
    print('Deriving Seed2 -> Seed3');
    _updateWithQuickHashing();
    _seed3 = _currentState;

    _savedDerivedStates[_derivationPath] = _currentState;
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
      memorySizeKB: 1024*1024*1024,
      salt: argon2Salt,
    );

    _currentState = argon2Algorithm.convert(_currentState).bytes;
  }

  /// Update the state with its hash taking presumably a quick time.
  void _updateWithQuickHashing() {
    var argon2Algorithm = Argon2(
      version: Argon2Version.v13,
      type: Argon2Type.argon2i,
      hashLength: 128,
      iterations: 1,
      parallelism: 1,
      memorySizeKB: 1024*1024,
      salt: argon2Salt,
    );

    _currentState = argon2Algorithm.convert(_currentState).bytes;
  }
}
