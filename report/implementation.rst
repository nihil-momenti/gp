Implementation
==============

Plan of Action
--------------

The plan was to create a simple general GP system in Ruby, then attempt to use
the system to solve the chosen dataset.  By building a general system the
testing of the system will be greatly simplified, a nice easy to learn function
such as ``x^2 + y^2`` can be used to verify the system.  Using Ruby provides a
nice easy interface to define the available functions, constants and variables
via meta-programing.

The first step in the program is the definition of the functions, constants and
variables.  Instead of hard-coding it was decided to create a simple domain
specific language (DSL) to allow them to be programmaticly defined at startup.
This will then be saved into an environment variable that will be added to the
required classes via meta-programing.

The individual algorithms will be stored as a tree, to run the code this tree
can be flattened by each node containing a representation of the basic code for
the node, this representation will then have each child node be substituted in
recursively down the tree till just a single string representing the function is
returned.  This string can then simply be eval-ed by Ruby and the output checked
against the fitness function.

Solution
--------

The DSL was created in a ``Builder`` class.  The constants and variables are
simply defined inside a YAML dictionary, variables just a mapping from variable
name to variable type, e.g. ``elevation: Number`` for the *elevation* variable
which is a *Number* type, constants are a mapping from the constant type to a
piece of Ruby code to generate a new random constant, e.g. ``Boolean: (rand >
0.5)`` for generating a *Boolean* constant using the inbuilt Ruby ``rand``
function.

Functions are a little more complex, a simple syntax was created that could be
parsed using just regular expressions and the required functions could be easily
created from.  A simple example of this syntax is the ``PLUS`` function with the
definition::
  
  PLUS: Number, Number -> Number
   => ({0} + {1})

This says that ``PLUS`` is a function that takes as input two ``Number`` s and
gives as a result a ``Number``, the Ruby code for the function is then given
with ``{n}`` used to embed the nth argument.


A more complex example is the definition of the ``IF`` function::

  IF: Boolean, <X>, <X> -> <X>
   => (if {0} then {1} else {2} end)

The main difference with this is the use of generics, any type that matches the
regex ``<.+?>`` is counted as a generic type.  During generation of the allowed
functions these are replaced with each of the constant types defined to produce
a set of functions.  So this ``IF`` function takes in a ``Boolean`` argument,
then 2 arguments of the same type and returns a result with the same type as the
last two arguments.  Again the Ruby code to define this functions is given last.

Once the environment has 
