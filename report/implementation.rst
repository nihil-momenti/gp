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

The individual algorithms will be stored as a tree, with each node containing a
representation of the basic code for the node.  To run the algorithm the tree
can be flattened by with each node's textual representation having the children
nodes substituted in recursively till just a single string representing the
function is returned.  This string can then simply be eval-ed by Ruby and the
output checked against the fitness function.

The population can be stored as a simple array of the individuals contained,
Ruby array's come with a ``sample`` method that will easily allow a random
subset of the population to be gathered for use in a tournament.

Algorithms will also have support for the basic operations such as *mutation*
and *crossover* added.  Another operation yet to be described that will be
supported is *simplification*, this will take an existing algorithm and simplify
any constant parts of the algorithm.  The random mutation and crossover
regularly creates bits of code like ``if (false) then (1 - (4 * 8)) else (4 + (9
- ((12 - 6) / 6))) end``, this can very easily be simplified down to just
``12``.

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

As well as the definitions the ``Builder`` is responsible for gathering other
configuration parameters such as; population size,
crossover/mutation/simplification/reproduction rates and max initial algorithm
height.

Once the environment has been set-up using the ``Builder`` the initial
population has to be produced.  This is achieved using a technique called
*ramped half-and-half* [koza:book]_.  This is a technique where algorithms are
generated using half *grow* and half *full* with the maximum algorithm height
being slowly increased as the population is created.  This is in order to create
an initial population with a variety of algorithm sizes and shapes.

Next the population has to be evolved.  This is done in the ``Population``
class, ``Array#sample`` is used to pick out a tournament of individuals to
compare.  These are then sorted by their scores and the best one or two as
required are picked off for the mutation and crossover operations.  This is
repeated until the new population is at the required size and this is then
returned.

The actual scoring is done inside the fitness function defined by the user.
This calls the algorithm with the required variables and compares the result to
what is expected.  Because of using a series of examples in the fitness function
this was set-up as a lower is better scoring system.  Each example that was
incorrectly classified was worth one point, each example that was correctly
classified zero and the average height of the algorithm's tree was worth 0.1 per
layer.

Implementation Issues
---------------------

The biggest issue with this implementation was speed, Ruby is definitely not the
fastest of languages.  Initially I believed the ease of implementation and
understandability of the code would out-weigh the speed disadvantage, but after
seeing how slow it actually is I now think a better method would be to build a
hybrid C/Ruby system.

The other major issue didn't arise until I attempted to classify the actual
dataset.  When learning the test set of just ``x^2 + y^2`` the best solution
would generally be found within 3-7 generations, around 1-3 minutes of
computation.  After verifying that it was running with the actual test set I
spawned four separate populations and left them running for a few hours.  Checking
on them later I was surprised to see them sitting at approximately 60GiB total
memory usage.  I'm still not sure whether this was a problem with my code, or if
I had just hit one of the known memory leaks in Ruby.  One issue with using a
new language with a problematic garbage collector.

Solutions
---------

The solution to both the above issues was the same: distributed computing.
There is a really nice background job queueing library called Resque [#]_.  By
using this with a Redis [#]_ database I could easily distribute the computation
around a few hundred computers on the university network.

.. [#] https://github.com/defunkt/resque
.. [#] http://redis.io

This also solves the second problem via Resque's architecture; each worker uses
a parent-child pair.  The parent simply loads the environment and waits for a
job, once a job arrives the parent forks a new child that does the processing,
when the child finishes it exits, freeing up the memory used during the run.

The slowest part of the system was calculating scores for each individual
algorithm; so the simplest way to distribute the system was to save each
population into a Redis list, have the workers pull individuals from this list,
compute their scores and push them into a new list.  Once the old list was empty
one worker pulls the entire new list in, creates the new generation, and pushes
the new generation back into the old list.

Because these were University computers I couldn't simply leave them all logged
in so the system had to be resilient to workers suddenly disappearing when
others used the computers.  Each individual wasn't very important overall so if
we lost a few when a worker disappeared this shouldn't affect the system.
Therefore we could simply have each worker only pulling one individual out of
the database at a time, then put it back in once scored before pulling the next
out.  If we lose any then the population size will be built back up when the
next generation is created.

The biggest problem would be if a worker crashed when creating the new
generation, at this point the worker has to have the entire population pulled
out to compare them all.  There were two parts to the reliability here; first,
the workers that could create the new generation were limited to only those on
the main computer science server; second, as each individual is pulled out of
the database a copy is pushed into a backup list.

Keeping the workers on the main server would probably be enough by itself.  This
is the same server that the Redis database is running on and Redis is a purely
memory-based database, so if the server were to crash everything would be lost
anyway.  The backup is more if the worker hits some strange error and gets
stuck.  If so the backup can be manually copied across into the old population
list and the job restarted.

The transformation of the system from a single-threaded, single-process system
into a distributed system was rushed and turned out a big hack, but it worked.
At its peak I was using approximately 440 workers distributed over around 130
computers.

.. [koza:book] temp
