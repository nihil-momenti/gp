Genetic Programming [poli08:fieldguide]_
------------------------------------------

Genetic programming (GP) is a form of evolutionary computation (EC), one of the
major subsets of machine learning.  One of the major advantages of genetic
programming over other methods is that the user does not need to specify any
sort of form or algorithm for the computer to use as a basis to solve the given
problem.  Instead the user simply has to supply a *fitness function* that can be
used to rank solutions, the algorithm then naturally evolves as part of the
learning process.

The Basics
++++++++++

The basic outline of GP is similar to other forms of EC, you start with an
initial randomised population, perform some method to select a good subset of
the population, then use this subset to generate a new generation of the
population.  In GP the population is made up of a collection of
programs/algorithms, these are generally tested against a given fitness function
and then a stochastic selection process finds the best and does the
transformation to the next generation.

Looking at this description the first decision that needs to be made is how to
represent the program.  There are generally two solutions to this, based off how
the simplest of current programming languages work, either a linear stack based
approach or a tree based approach.

Out of the two approach the linear stack based approach is definitely easier to
implement, especially when creating the algorithm for transforming one
generation to the next.  Unfortunately it is a very rare approach in modern
programming languages, likely because it is a lot harder to write easy to
understand, decomposable code with.  Other than esoteric languages such as
Befunge or Golfscript the most widely used form of this would have to be the
many different forms of assembly code.  It is also almost completely absent in
literature of the subject, this is disappointing as I believe that it could be a
very effective avenue.

The tree based approach is more similar to current languages, it easily allows
representation of code such as [``IF (a == 0) THEN (2) ELSE (4) END``] as a
simple six node tree, see `Figure 1`__.  This provides a few problems when
attempting to construct a new generation, but nothing that can't be overcome.

__
.. figure:: images/simple-tree

  A simple tree representing [``IF (a == 0) THEN (2) ELSE (4) END``].

The decision of what possible nodes to have in the tree is very important,
generally there are three types of nodes; function nodes, variable nodes and
constant nodes.  Variable and constant nodes are only leaf nodes while function
nodes are all the non-leaf nodes.  The purpose of these nodes is completely
defined in their descriptions, variable nodes contain the input variables of the
algorithm, constant nodes contain constants for comparison against the variables
and function nodes contain functions such as ``IF`` and ``==`` as seen above.

The selection process in all EC methods is very similar, individuals are
selected by a probabilistic function based on their fitness.  The most common
method employed in GP is *tournament selection*, this is where a subset of the
population is randomly selected and sorted in order of fitness.  The top ``n``
individuals are then chosen as required by the crossover or mutation operators.

The last part of the process is how to perform crossover and mutation, this is
where GP differs the most from other evolutionary algorithms.  The most common
form of crossover used in GP is *subtree crossover*.  Two parents are selected
then a random node in each is chosen, the first parent is then copied and the
chosen node is replaced with the chosen node from the second parent.

For mutation the most commonly used operation is *subtree mutation*.  This is
when a random point in the individual is selected then replaced with a new
randomly generated subtree.  To try and keep a semi-consistent size the
generated subtree is kept to approximately the same height as the removed
subtree.

.. [poli08:fieldguide] temp
