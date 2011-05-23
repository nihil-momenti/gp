Conclusion
==========

What I Learned
--------------

I learned a lot about what goes into making GP work.  The experience of actually
writing the whole system from the ground up has forced me to learn exactly how
everything goes together.

After having written this incarnation of the system I think if I were doing
anymore work on it I would throw it away and restart from scratch.  My initial
plan worked well for a first attempt, but the experience that it has brought me
lets me see how ineffective it actually is.  The goal of having just a very
simple DSL/syntax for specifying the available functions especially was very
naïve, there is no simple way to show things such as the simplification of ``IF
(true) then (A) else (B)`` to just ``A``.

Future Work
-----------

As stated above, if I had more time I would go back and completely re-write the
system.  I would probably start with the goal of making it distributed, maybe
aiming to make it extensible with ideas from geographically distributed GP,
where instead of just a single population multiple semi-independent
sub-populations are used and restrictions are placed on the possibilites of
cross-over between different *demes* [kinnear:DHaeseleer]_ [langdon:book]_.

This distribution would still use Redis backing, the simplicity of a key-value
store and speed of its in-memory nature make it much more suited than some SQL
based database.  However I would get rid of Resque and use a self-built worker
model to optimise it for this application, Resque is designed for queuing up
background jobs on web servers rather than traditional distributed computing.

I would also re-write the lower layers in C and just use Ruby for the
higher-level non-time-critical functions.  This would provide a big speed boost
and allow for much larger populations to be utilised.

.. [kinnear:DHaeseleer] temp
.. [langdon:book] temp
