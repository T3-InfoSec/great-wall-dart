## This is a small documentation


The great wall protocol uses the `great_wall_protocol.dart` file for the main protocol logic


The `GreatWall` class currently has 3 main knowledge types:

- `FormosaKnowledge`: this is the knowledge that uses entropy to generate the tacit knowledge (mnemonic)
- `HashVizKnowledge`: this is the knowledge that uses a hash value and generates the tacit knowledge (visualization blocks)
- `DynamicFractalKnowledge`: this is the knowledge that uses a exponent (2<=real <= 3, 0 <= imag <= 1) to generate the tacit knowledge (fractal coordinates)


### Data variables

The `GreatWall` class has the following state values:

- _sa0: the initial seed of the protocol
- _sa1: the state after the first derivation
- _sa2: the state after the second derivation
- _sa3: the state after the third derivation
- _currentNode: the current node that the protocol is at
- _currentLevel: the current level that the protocol is at
- _shuffledArityIndexes: the shuffled indexes of the current level (children choices)
- _shuffledCurrentLevelKnowledgePalettes: the shuffled knowledge Palettes of the current level
- _tacitKnowledge: the tacit knowledge that the protocol is using
- _derivationPath: this contains the entire derivation path of the protocol till the current node
- _savedDerivationStates: this contains the saved derivation states of the protocol this might be a child or a cousin node it is used to memoize the solution to reduce rework
- _savedDerivedPathKnowledge: this contains the saved derived path knowledge of the protocol this might be a child or a cousin node it is used to memoize the solution to reduce rework

it also contains certain flags to check if the protocol is in a certain state

- _isFinished: this flag is set to true when the protocol is finished
- _isCancelled: this flag is set to true when the protocol is cancelled
- _isInitialized: this flag is set to true when the protocol is initialized
- _isStarted: this flag is set to true when the protocol is started

- _treeArity: this is the arity of the tree
- _treeDepth: this is the depth of the tree
- _timeLockPuzzleParam: this is the time lock puzzle parameter

### Methods

#### `GreatWall` constructor

When we create an instance of the `GreatWall` class, we can use 4 parameters:
- treeArity: this means how many children each node can have
- treeDepth: this means how many levels the tree will have
- timeLockPuzzleParam: this means how complex we want the time lock puzzle to be
- tacitKnowledge: here we provide the method that derives the tacit knowledge from configs and params

The constructor also calls the `initialDerivation` method which initializes the protocol

#### `initialDerivation` method
This method initializes the protocol by initializing the 4 `sa` parameters, the current node,
the current level, the shuffled arity indexes, the shuffled current Level knowledge palette,
the tacit knowledge.
Here the derivation path , the saved derivation states, the saved derived path knowledge is cleared.
The flags are set to false and the protocol is initialized


#### `startDerivation` method

This checks if the protocol is initialized, else it throws an error.
This method starts the derivation process by calling the `makeExplicitDerivation` method
and setting the `_isStarted` flag to true

#### `makeExplicitDerivation` method

This starts the one time derivation required to get to the next node.
It checks if the protocol is cancelled else it derives the sa0, sa1, sa2, sa3 and sets the current node and level
It added the current node hash to the savedDerivedStates
It then finally generates the Knowledge Palette for the current level using the `generateLevelKnowledgePalette` method

#### `generateLevelKnowledgePalette` method

This method takes a level hash and generates the knowledge palette for that level
It first checks if the `_savedDerivedPathKnowledge` contains the current derivation path (this might happen if we backtrack) if it exists it returns that without doing the calculation
Else it generates the knowledge palette using the tacit knowledge and the current level hash.

To generate the knowledge palette it first calls the `_shuffleArityIndexes` method to shuffle the indexes
Then it generates the knowledge palette depending on the tacit knowledge type 
It goes through the shuffled indexes and generates the knowledge palette for each index
The initial value for each tacit knowledge is the current level hash, and the adjustmentValue is the index

For `FormosaKnowledge` it generates the tacit knowledge using the `FormosaTacitKnowledge` class.

Similarly for `HashVizKnowledge` it generates the tacit knowledge using the `HashVizTacitKnowledge` class.

Once all the knowledge palettes are generated it saves the derived path knowledge, the
`_shuffledCurrentLevelKnowledgePalettes` to the generated knowledge palettes and returns the
generated knowledge palettes


#### `shuffleArityIndexes` method

This just generates a list of indexes from 0 to the treeArity and shuffles them using a
cryptographically secure random number generator.
it then sets the `_shuffledArityIndexes` to the shuffled indexes

#### `makeTacitDerivation` method

This needs an index denoting the index of the child that was selected.
It then performs the routine checks to see if the protocol is cancelled or finished and if we are on the correct path.
it then increments the current level and adds the current choice to the derivation path.
We also check if the current path is in the saved derived path knowledge if it is we return that
knowledge else we generate the new Node hash using the formula $L_{i+1, j} = H(L_i | j)$ where $L_i$
is the current level hash and j is the index of the child knowledge palette for the current level
here the `|` denotes concatenation also the hash function is the argon2 hash function using the
`generateLevelKnowledgePalette` method.

#### `_retunDerivationOneLevelBack` method

This method is used to return one level back in the derivation path.
It checks if the protocol is cancelled or finished and if we are on the correct path.
we then decrement the current level and remove the last choice from the derivation path.
We set the currentNode.hash to the last hash in the derivation path and we return the last


#### `finishDerivation` method

This method is used to finish the derivation process.
It checks if the protocol is cancelled or finished and if we are on the correct path.
It declares a new variable `tempPath` which is then used to traverse the derivation path and get the
saved derived path knowledge and reiterate over the previous path.


### Control flow


The control flow of the protocol is as follows:

- We initialize the protocol using the `initialDerivation` method
- We start the derivation using the `startDerivation` method which calls the `makeExplicitDerivation` method
- The `makeExplicitDerivation` method generates the knowledge palette for the current level for level 0 it is SA3 which is derived from SA2 which is derived from SA1 which is derived from SA0
- The knowledge palette is generated using the tacit knowledge and the current level hash
- The knowledge palette is shuffled and the protocol is started
- We then make the tacit derivation using the `makeTacitDerivation` method which generates the next level hash. This is invoke after the user selects a child node.
- We can also return one level back using the `_retunDerivationOneLevelBack` method
- We can finish the derivation using the `finishDerivation` method
- The protocol can be cancelled at any time using the `_cancelDerivation` method
- The protocol can be reset using the `initialDerivation` method
