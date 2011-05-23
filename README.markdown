# GP - genetic programming in Ruby

## What this is

This repository contains my project for [COSC401][], a fourth year machine
learning paper at the University of Canterbury.  See [the report](./report/report.pdf) for
details on the implementation.

## How to run

At the moment this source is very system specific.  My original plan was to
produce a genetic programming gem and utilise this for my assignment, but
because of time constraints I had to simple hack together a working program.
Then I wound up using over 60GiB of memory during my initial testing run and had
to throw together a distributed system with Resque.  All-in-all this source has
become a tangled mess held together with coffee and energy drinks.

If you do wish to try and get this running yourself there are a few pointers I
can give you:

 1. You will need a Redis database running, Resque requires Redis and the
    distribution of the population also utilises it.
 
 2. Look at `lib/environment.rb` first.  The Redis location at least will need
    to be changed.

 3. `run-clients.rb` shows how I spawned the workers into a screen session if
    they weren't already running, should be mostly directly usable.  The
    hostname matching was used to make sure that jobs were only processed on one
    host to keep the filesystem based logging usable.

 4. `spawn-clients.rb` ssh's into each host and runs `run-clients.rb`, should
    simply need to change line 3 to a list of your available hosts.

 5. `shutdown-clients.rb` and `kill-clients.rb` are similar to the spawner, they
    ssh in to each host and then either send `QUIT` (shutdown after finishing
    current job) or `TERM` (kill child and quit now) to all running Resque
    workers.  NOTE: this doesn't try and find only the workers that are working
    on this, it will attempt to kill any Resque workers on the host.

## Results

The generation of the results used in the report can be found in [this gist](https://gist.github.com/985347).

[COSC401]: http://www.canterbury.ac.nz/courseinfo/GetCourseDetails.aspx?course=COSC401&occurrence=11S1(C)&year=2011
           "The COSC401 information page"
