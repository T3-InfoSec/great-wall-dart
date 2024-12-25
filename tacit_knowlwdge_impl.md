# Docs for the tacit knowledge implementation

## Tacit Knowledge Param class

- argon2Salt: The salt for the argon2 hash function
- bytesCount: The number of bytes to get from the generated hash (default is 4)
- name: The name of the tacit knowledge parameter
- initialValue: The initial value is the current level hash 
- adjustmentValue: The adjustment value is the index of the child knowledge palette for the current level

## Tacit Knowledge methods

### `_computeValue` method

This method is used to compute the value of the tacit knowledge. It uses the argon2 hash function to
generate the hash of the concatenation of the current level hash and the index of the child
knowledge palette for the current level.

The formula used is 
$$
L_{i+1, j} = H(H(L_i) | j)
$$
where $L_i$ is the current level hash and j is the index of the child knowledge palette for the
current level.
Also the L_i | j denotes concatenation.

We then use the first `bytesCount` bytes from the generated hash as the value of the tacit knowledge.



## Tacit Knowledge class

This is an abstract class that is used to define the tacit knowledge.

- configs: This is the configuration for the tacit knowledge, like the theme(wordlist for Formosa, 
or the color scheme for DynamicFractal, or the colors length for HashViz)
- param: This is an instance of the TacitKnowledgeParam class which has initial state and adjustment
value

### `knowledge` getter

This is a getter method that returns the value of the tacit knowledge. It needs to be implemented by
the subclasses. It uses the params and the configs to compute the value of the tacit knowledge
depending upon the type of tacit knowledge.

## FormosaTacitKnowledge class

This is a subclass of the TacitKnowledge class and is used to define the tacit knowledge for the
Formosa format.

We override the `knowledge` getter method to return the value of the tacit knowledge for the Formosa
and the params and configs.

In the `knowledge` getter method we use the `Formosa` class to generate formosa seed.

## HashVizTacitKnowledge class

This is a subclass of the TacitKnowledge class and is used to define the tacit knowledge for the
HashViz format.

We override the `knowledge` getter method to return the value of the tacit knowledge for the HashViz
and the params and configs.

In the `knowledge` getter method we use the `HashViz` class to generate hashviz visualization.
