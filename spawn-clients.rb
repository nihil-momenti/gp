#!/usr/bin/env ruby

hosts = `cat /netfs/share/whichprinter/csse_lab?  | sed 's/$/.cosc.canterbury.ac.nz 22/' | xargs -n2 nc -w 2 -z -v 2> /dev/null | egrep -o "cosc[0-9]+\.cosc\.canterbury\.ac\.nz"`.split("\n")
hosts << 'localhost'
hosts.each do |host|
  puts "Spawning on #{host}"
  puts `ssh -o ConnectTimeout=2 #{host} ~/.rvm/wrappers/ruby-1.9.2-p180/ruby ~/sources/gp/run-clients.rb`
end
