// TODO: Complete the copyright.
// Copyright (c) 2024, ...

import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

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
  late Node _currentNode;
  late int _currentLevel;
  late List<int> _shuffledArityIndexes;
  late Map<Uint8List, TacitKnowledge> _shuffledCurrentLevelKnowledgePalettes;

  final TacitKnowledge _tacitKnowledge;

  final DerivationPath _derivationPath = DerivationPath();
  final Map<DerivationPath, Uint8List> _savedDerivedStates = {};
  final Map<DerivationPath, Map<Uint8List, TacitKnowledge>> _savedDerivedPathKnowledge =
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

  /// Get the current node state of the protocol derivation process.
  Node get currentNode => _currentNode;

  /// Get the tacit knowledge palettes of current level.
  List<TacitKnowledge> get currentLevelKnowledgePalettes =>
      _shuffledCurrentLevelKnowledgePalettes.entries.map((entry) => entry.value).toList();

  /// Get the result of the protocol derivation process.
  ///
  /// The result requires calling [finishDerivation] first.
  Uint8List? get derivationHashResult => (isFinished) ? _currentNode.value : null;

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
  set sa0(Sa0 sa0) {
    initialDerivation();
    _sa0 = sa0;
    _currentNode = Node(_sa0.formosa.value, nodeDepth: 1); // TODO: Review the need for the use of node before tacit derivation
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
  void finishDerivation() {  // todo: this method is useless or incomplete
    if (isStarted && isInitialized && _currentLevel == treeDepth + 1) {
      TacitKnowledge tacitKnowledge = derivationTacitKnowledge;

      switch (tacitKnowledge) {
        case FormosaTacitKnowledge():
          DerivationPath tempPath = DerivationPath();
          List<TacitKnowledge> chosenKnowledgeList = [];
          for (Uint8List node in _derivationPath) {
            Map<Uint8List, TacitKnowledge> levelKnowledgeList =
                _savedDerivedPathKnowledge[tempPath.copy()]!;
            var matchedKey = levelKnowledgeList.keys.firstWhere(
                    (key) => ListEquality().equals(key, node)
            );
            TacitKnowledge chosenKnowledge = levelKnowledgeList[matchedKey]!;
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
          for (Uint8List node in _derivationPath) {
            Map<Uint8List, TacitKnowledge> levelKnowledgeList =
            _savedDerivedPathKnowledge[tempPath]!;
            var matchedKey = levelKnowledgeList.keys.firstWhere(
                    (key) => ListEquality().equals(key, node)
            );
            TacitKnowledge chosenKnowledge = levelKnowledgeList[matchedKey]!;
            chosenKnowledgeList.add(chosenKnowledge);
            tempPath.add(node);
          }
        case DynamicFractalTacitKnowledge():
          DerivationPath tempPath = DerivationPath();
          for (Uint8List node in _derivationPath) {
            tempPath.add(node);
          }

      }
      _isFinished = true;
    } else {
      print('Derivation does not started yet or not completed.');
      _isFinished = false;
    }
  }

  Uint8List _computeHash(String data) {
    Uint8List adjustedData = Uint8List.fromList(data.runes.map((charCode) => charCode & 0xFF).toList());
    return argon2derivationService.deriveWithModerateMemory(1, EntropyBytes(adjustedData)).toBytes();
  }

  /// Reset the [GreatWall] protocol derivation process to its initial state.
  void initialDerivation() {
    _sa0 = Sa0(Formosa(Uint8List(128), FormosaTheme.bip39));
    _sa1 = Sa1();
    _sa2 = Sa2();
    _sa3 = Sa3();
    _currentLevel = 0;
    _shuffledArityIndexes = <int>[];
    _shuffledCurrentLevelKnowledgePalettes = {};

    derivationTacitKnowledge = _tacitKnowledge;
    _derivationPath.clear();
    _savedDerivedStates.clear();
    _savedDerivedPathKnowledge.clear();

    _isInitialized = true;
    _isStarted = false;
    _isCanceled = false;
    _isFinished = false;
    print('initialization completed');
  }

  /// Drive the [_currentNode] from the user choice [choice].
  ///
  /// If [choice] is 0, the protocol will go back one level to its
  /// previous state, if it is greater 0 the protocol will update the state
  /// depending on this choice.
  void makeTacitDerivation({required String choice}) {
    if (isStarted &&
        !isCanceled &&
        _savedDerivedPathKnowledge.containsKey(_derivationPath)) {
      if (choice != "0") {
        _currentLevel += 1;
        Uint8List choiceHash = _computeHash(choice);
        _derivationPath.add(choiceHash);

        if (_savedDerivedStates.containsKey(_derivationPath)) {
          _currentNode.value = _savedDerivedStates[_derivationPath.copy()]!;
        } else {
          _currentNode.value = Uint8List.fromList(
            _currentNode.value + choiceHash
          );
          _currentNode.value = argon2derivationService.deriveWithModerateMemory(1, _currentNode).value;
          _savedDerivedStates[_derivationPath.copy()] = _currentNode.value;
        }

        generateLevelKnowledgePalettes(_currentNode.value);
      } else {
        _returnDerivationOneLevelBack();
        generateLevelKnowledgePalettes(_currentNode.value);
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
  // todo: cleanup needed, the following method is not used
  Uint8List getSelectedNode(Uint8List currentHash, String choiceNumber) {
    Uint8List choiceHash = _computeHash(choiceNumber);
    Uint8List hash = Uint8List.fromList(currentHash + choiceHash);
    return argon2derivationService.deriveWithModerateMemory(1, EntropyBytes(hash)).value;
  }

  /// Generates palettes of knowledge for the current derivation level.
  ///
  /// If the current path has saved palettes, it uses them. Otherwise,
  /// creates and saves a list with length [GreatWall.treeArity] of shuffled
  /// palettes of [TacitKnowledge]. Returns the list of shuffled palettes.
  List<TacitKnowledge> generateLevelKnowledgePalettes([Uint8List? currentHash, String selectedPoint = '0']) {
    TacitKnowledge tacitKnowledge = derivationTacitKnowledge;
    if(currentHash == null) {
      throw Exception('The current hash is null. This is an invalid argument.');
    }

    if (_savedDerivedPathKnowledge.containsKey(_derivationPath.copy())) {
      _shuffledCurrentLevelKnowledgePalettes =
           _savedDerivedPathKnowledge[_derivationPath.copy()]!;
    } else {
      _shuffleArityIndexes();
      switch (tacitKnowledge) {
        case FormosaTacitKnowledge():
          Map<Uint8List, TacitKnowledge> shuffledFormosaPalettes = {};
            for (final arityIdx in _shuffledArityIndexes) {
              Uint8List choiceHash = _computeHash(arityIdx.toString());
              shuffledFormosaPalettes[choiceHash] = FormosaTacitKnowledge(
                configs: tacitKnowledge.configs,
                param: TacitKnowledgeParam(
                  name: 'formosaParam',
                  initialState: currentHash,
                  adjustmentValue: choiceHash,
                ),
              );
            }
          _savedDerivedPathKnowledge[_derivationPath.copy()] =
              shuffledFormosaPalettes;
          _shuffledCurrentLevelKnowledgePalettes = shuffledFormosaPalettes;
        case HashVizTacitKnowledge():
          Map<Uint8List, HashVizTacitKnowledge> shuffledHashVizPalettes = {};
            for (final arityIdx in _shuffledArityIndexes)
              {
                Uint8List choiceHash = _computeHash(arityIdx.toString());
                shuffledHashVizPalettes[choiceHash]=  HashVizTacitKnowledge(
                  configs: tacitKnowledge.configs,
                  param: TacitKnowledgeParam(
                    name: 'hashvizParam',
                    initialState: currentHash,
                    adjustmentValue: choiceHash,
                  ),
                );
              }
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

        case DynamicFractalTacitKnowledge():
          Map<Uint8List, DynamicFractalTacitKnowledge> shuffledDynamicFractalPalettes = {};
          Uint8List choiceHash = _computeHash(selectedPoint.toString());
          shuffledDynamicFractalPalettes[choiceHash] = DynamicFractalTacitKnowledge(
                configs: tacitKnowledge.configs,
                param: TacitKnowledgeParam(
                  name: 'dynamicFractalParam',
                  initialState: currentHash,
                  adjustmentValue: choiceHash,
                ),
              );
          _savedDerivedPathKnowledge[_derivationPath.copy()] = shuffledDynamicFractalPalettes;
          _shuffledCurrentLevelKnowledgePalettes = shuffledDynamicFractalPalettes;
      }
    }
    if(_shuffledCurrentLevelKnowledgePalettes.isEmpty) {
      return [];
    }
    List<TacitKnowledge> knowledgePalettes = [];
    _shuffledCurrentLevelKnowledgePalettes.forEach((key, value) {
      knowledgePalettes.add(value);
    });
    return knowledgePalettes;
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
    _currentNode.value = _sa1.value; // TODO: Review the need for the use of node before derivation
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }

    _sa2.from(_timeLockPuzzleParam, _sa1);
    _currentNode.value = _sa2.value; // TODO: Review the need for the use of node before derivation
    if (_isCanceled) {
      print('Derivation canceled');
      return;
    }

    _sa3.from(_sa0, _sa2);
    _currentNode.value = _sa3.value;
    _savedDerivedStates[_derivationPath.copy()] = _currentNode.value;
    // Prepare the level 1 of tacit derivation process.
    _currentLevel += 1;
    generateLevelKnowledgePalettes(_currentNode.value);
  }

  /// Go back one level to the previous derivation state.
  void _returnDerivationOneLevelBack() {
    if (_currentLevel == 0 || _currentLevel == 1) return;

    if (_isFinished) _isFinished = false;

    _currentLevel -= 1;
    _derivationPath.pop();

    _currentNode.value = _savedDerivedStates[_derivationPath.copy()]!;
  }

  /// Fill and shuffles a list with numbers in range [GreatWall.treeArity].
  void _shuffleArityIndexes() {
    _shuffledArityIndexes = [for (var idx = 1; idx <= treeArity; idx++) idx];
    _shuffledArityIndexes.shuffle(Random.secure());
  }
}
