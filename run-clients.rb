#!/usr/bin/env ruby

running = /.*gp-workers.*/ =~ `screen -ls`
`screen -d -m -S gp-workers zsh -c 'cd ~/sources/gp && ~/.rvm/wrappers/ruby-1.9.2-p180/rake gp:workers:start'` unless running
puts running ? "Already running" : "Started workers"
