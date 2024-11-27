// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:math';
import 'dart:typed_data';

import 'package:great_wall/src/cryptographic/domain/pa0.dart';
import 'package:great_wall/src/cryptographic/domain/sa0.dart';
import 'package:great_wall/src/cryptographic/domain/sa1.dart';
import 'package:great_wall/src/cryptographic/domain/sa2.dart';
import 'package:great_wall/src/cryptographic/domain/sa3.dart';
import 'package:great_wall/src/cryptographic/domain/node.dart';
import 'package:great_wall/src/cryptographic/service/argon2_derivation_service.dart';

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
  static final int bytesCount = 4;
  static final Argon2DerivationService argon2derivationService = Argon2DerivationService();

  // Protocol derivation states
  late Sa0 _sa0;
  late Sa1 _sa1;
  late Sa2 _sa2;
  late Sa3 _sa3;
  late Node _node;
  late int _currentLevel;
  late List<int> _shuffledArityIndexes;
  late List<TacitKnowledge> _shuffledCurrentLevelKnowledgePalettes;

  final TacitKnowledge _tacitKnowledge;

  final DerivationPath _derivationPath = DerivationPath();
  final Map<DerivationPath, Uint8List> _savedDerivedStates = {};
  final Map<DerivationPath, List<TacitKnowledge>> _savedDerivedPathKnowledge =
      {};

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
  /// hard-memory hashing process; bigger number harder process. The
  /// [tacitKnowledge] is used to generate palettes of tacit knowledge to be
  /// used in the protocol hash derivation process.
  GreatWall({
    required int treeArity,
    required int treeDepth,
    required int timeLockPuzzleParam,
    required TacitKnowledge tacitKnowledge,
  })  : _treeArity = treeArity.abs(),
        _treeDepth = treeDepth.abs(),
        _timeLockPuzzleParam = timeLockPuzzleParam.abs(),
        _tacitKnowledge = tacitKnowledge {
    initialDerivation();
  }

  /// Get the current hash state of the protocol derivation process.
  Uint8List get currentHash => _node.currentHash;

  /// Get the tacit knowledge palettes of current level.
  List<TacitKnowledge> get currentLevelKnowledgePalettes =>
      _shuffledCurrentLevelKnowledgePalettes;

  /// Get the result of the protocol derivation process.
  ///
  /// The result requires calling [finishDerivation] first.
  Uint8List? get derivationHashResult => (isFinished) ? _node.currentHash : null;

  /// Get the current level of the protocol derivation process.
  int get derivationLevel => _currentLevel;

  /// The tacit knowledge that will be used in the protocol hash derivation
  /// process.
  TacitKnowledge get derivationTacitKnowledge => _tacitKnowledge;

  Map<DerivationPath, Uint8List> get savedDerivedStates => _savedDerivedStates;

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

  /// Set the value of the [pa0] that you need to hash it by using
  /// [GreatWall] protocol.
  // TODO: Make sure the password match one of the formosa theme.
  set sa0(Pa0 pa0) {
    initialDerivation();
    _sa0.from(pa0);
    _node = Node(_sa0.seed); // TODO: Review the need for the use of node before tacit derivation
  }

  /// Get the param of the memory hard hashing process.
  int get timeLockPuzzleParam => _timeLockPuzzleParam;

  /// Get the tree arity of the derivation process.
  int get treeArity => _treeArity;

  /// Get the tree depth of the derivation process.
  int get treeDepth => _treeDepth;

  /// Cancel the current running derivation process.
  ///
  /// This method stops the ongoing derivation process and marking the process
  /// as canceled. If the derivation has not started, a message is printed
  /// indicating that the process is not running, and the cancel flag remains
  /// `false`. The cancel flag can later be checked using
  /// [GreatWall.isCanceled].
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
        // case FractalTacitKnowledge():
        //   DerivationPath tempPath = DerivationPath();
        //   List<TacitKnowledge> chosenKnowledgeList = [];
        //   for (int node in _derivationPath) {
        //     List<TacitKnowledge> levelKnowledgeList =
        //         _savedDerivedPathKnowledge[tempPath]!;
        //     TacitKnowledge chosenKnowledge = levelKnowledgeList[node - 1];
        //     chosenKnowledgeList.add(chosenKnowledge);
        //     tempPath.add(node);
        //   }
        case HashVizTacitKnowledge():
          DerivationPath tempPath = DerivationPath();
          List<TacitKnowledge> chosenKnowledgeList = [];
          for (int node in _derivationPath) {
            List<TacitKnowledge> levelKnowledgeList =
                _savedDerivedPathKnowledge[tempPath]!;
            TacitKnowledge chosenKnowledge = levelKnowledgeList[node - 1];
            chosenKnowledgeList.add(chosenKnowledge);
            tempPath.add(node);
          }
      }
      _isFinished = true;
    } else {
      print('Derivation does not started yet or not completed.');
      _isFinished = false;
    }
  }

  /// Reset the [GreatWall] protocol derivation process to its initial state.
  void initialDerivation() {
    _sa0 = Sa0();
    _sa1 = Sa1();
    _sa2 = Sa2();
    _sa3 = Sa3();
    _node = Node(_sa0.seed); // TODO: Review the need for the use of node before derivation
    _currentLevel = 0;
    _shuffledArityIndexes = <int>[];
    _shuffledCurrentLevelKnowledgePalettes = <TacitKnowledge>[];

    derivationTacitKnowledge = _tacitKnowledge;
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
          _node.update(_savedDerivedStates[_derivationPath]!);
        } else {
          _node.update(Uint8List.fromList(
            _node.currentHash + [_shuffledArityIndexes[choiceNumber - 1]],
          ));
          _node.update(argon2derivationService.deriveWithModerateMemory(_node.currentHash));
          _savedDerivedStates[_derivationPath.copy()] = _node.currentHash;
        }

        generateLevelKnowledgePalettes(_node.currentHash);
      } else {
        _returnDerivationOneLevelBack();
        generateLevelKnowledgePalettes(_node.currentHash);
      }
    } else {
      print(
        'Derivation does not started yet. Please, start the derivation'
        ' process first.',
      );
    }
  }

  /// Starts the derivation process if initialized.
  ///
  /// If the derivation is initialized, then the derivation process will be
  /// start. Otherwise, logs a message and sets start flag to `false`. The
  /// start flag can later be checked using [GreatWall.isStarted].
  void startDerivation() {
    if (isInitialized) {
      _makeExplicitDerivation();
      _isStarted = true;
    } else {
      print('Derivation does not initialized yet.');
      _isStarted = false;
    }
  }

  Uint8List getSelectedNode(Uint8List currentHash, int choiceNumber) {
    Uint8List hash = Uint8List.fromList(currentHash + [_shuffledArityIndexes[choiceNumber - 1]]);
    return argon2derivationService.deriveWithModerateMemory(hash);
  }

  /// Generates palettes of knowledge for the current derivation level.
  ///
  /// If the current path has saved palettes, it uses them. Otherwise,
  /// creates and saves a list with length [GreatWall.treeArity] of shuffled
  /// palettes of [TacitKnowledge]. Returns the list of shuffled palettes.
  List<TacitKnowledge> generateLevelKnowledgePalettes(Uint8List currentHash) {
    TacitKnowledge tacitKnowledge = derivationTacitKnowledge;

    if (_savedDerivedPathKnowledge.containsKey(_derivationPath.copy())) {
      _shuffledCurrentLevelKnowledgePalettes =
          _savedDerivedPathKnowledge[_derivationPath]!;
    } else {
      _shuffleArityIndexes();
      switch (tacitKnowledge) {
        case FormosaTacitKnowledge():
          List<FormosaTacitKnowledge> shuffledFormosaPalettes = [
            for (final arityIdx in _shuffledArityIndexes)
              FormosaTacitKnowledge(
                configs: tacitKnowledge.configs,
                param: TacitKnowledgeParam(
                  name: 'formosaParam',
                  initialState: currentHash,
                  adjustmentValue: Uint8List.fromList([arityIdx]),
                ),
              )
          ];
          _savedDerivedPathKnowledge[_derivationPath.copy()] =
              shuffledFormosaPalettes;
          _shuffledCurrentLevelKnowledgePalettes = shuffledFormosaPalettes;
        case HashVizTacitKnowledge():
          List<HashVizTacitKnowledge> shuffledHashVizPalettes = [
            for (final arityIdx in _shuffledArityIndexes)
              HashVizTacitKnowledge(
                configs: tacitKnowledge.configs,
                param: TacitKnowledgeParam(
                  name: 'hashvizParam',
                  initialState: currentHash,
                  adjustmentValue: Uint8List.fromList([arityIdx]),
                ),
              )
          ];
          _savedDerivedPathKnowledge[_derivationPath.copy()] =
              shuffledHashVizPalettes;
          _shuffledCurrentLevelKnowledgePalettes = shuffledHashVizPalettes;
        // case FractalTacitKnowledge():
        //   List<FractalTacitKnowledge> shuffledFractalPalettes = [
        //     for (final arityIdx in _shuffledArityIndexes)
        //       FractalTacitKnowledge(
        //         config: tacitKnowledge.configs,
        //         param: TacitKnowledgeParam(
        //           name: 'fractalParam',
        //           initialState: _currentHash,
        //           adjustmentValue: Uint8List.fromList([arityIdx]),
        //         ),
        //       )
        //   ];
        //   _savedDerivedPathKnowledge[_derivationPath.copy()] =
        //       shuffledFractalPalettes;
        //   _shuffledCurrentLevelKnowledgePalettes = shuffledFractalPalettes;
        // case HashVizTacitKnowledge():
        //   List<FractalTacitKnowledge> shuffledFractalPalettes = [];
        //   shuffledPalettes = shuffledFractalPalettes;
      }
    }
    return _shuffledCurrentLevelKnowledgePalettes;
  }

  /// Performs the explicit derivation process, updating seeds and hashes.
  ///
  /// This process of derivation include in the following order: Logs each
  /// step of the derivation from Seed0 to Seed3. Updates
  /// [GreatWall.currentHash] with new values after each step. Saves the
  /// final hash state and increments the current level. Generates
  /// level-specific knowledge palettes.
  void _makeExplicitDerivation() {
    _sa1.from(_sa0);
    _node.update(_sa1.seed); // TODO: Review the need for the use of node before derivation
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }

    _deriveSa2FromSa1();
    _node.update(_sa2.seed); // TODO: Review the need for the use of node before derivation
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }

    _sa3.from(_sa0, _sa2);
    _node.update(_sa3.seed);
    _savedDerivedStates[_derivationPath.copy()] = _node.currentHash;

    // Prepare the level 1 of tacit derivation process.
    _currentLevel += 1;
    generateLevelKnowledgePalettes(_node.currentHash);
  }

  /// Go back one level to the previous derivation state.
  void _returnDerivationOneLevelBack() {
    if (_currentLevel == 0 || _currentLevel == 1) return;

    if (_isFinished) _isFinished = false;

    _currentLevel -= 1;
    _derivationPath.pop();

    _node.update(_savedDerivedStates[_derivationPath]!);
  }

  /// Fill and shuffles a list with numbers in range [GreatWall.treeArity].
  void _shuffleArityIndexes() {
    _shuffledArityIndexes = [for (var idx = 0; idx < treeArity; idx++) idx];

    _shuffledArityIndexes.shuffle(Random.secure());
  }

  /// Derives SA2 from SA1 through multiple iterations of a long hashing process.
  ///
  /// The derivation process can be affected by the [timeLockPuzzleParam]. If this value
  /// is greater than 0, the method will perform the derivation [timeLockPuzzleParam] times.
  /// If the operation is canceled during the derivation, it will stop and print a cancellation message.
  ///
  /// In order to be able to test in a development environment, the long hashing is skipped
  /// if [timeLockPuzzleParam] has a value of 0. This is an unsafe option and is not recommended
  /// for use in production as it bypasses the intended cryptographic process.
  void _deriveSa2FromSa1() {
    print('Deriving SA1 to SA2');
    if (timeLockPuzzleParam > 0) {
      for (int step = 0; step < timeLockPuzzleParam; step++) {
        if (_isCanceled) {
          print('Derivation canceled during long hashing.');
          return;
        }
        _sa2.from(_sa1);
      }
    }
  }
}
