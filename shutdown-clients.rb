#!/usr/bin/env ruby

hosts = `cat /netfs/share/whichprinter/csse_lab?  | sed 's/$/.cosc.canterbury.ac.nz 22/' | xargs -n2 nc -w 2 -z -v 2> /dev/null | egrep -o "cosc[0-9]+\.cosc\.canterbury\.ac\.nz"`.split("\n")
hosts << 'localhost'
hosts.each do |host|
  puts "Shutting down workers on #{host}"
  puts `ssh -o ConnectTimeout=2 #{host} 'ps -e -o pid,cmd | grep resque | grep -v web | grep -v grep | grep -Eo "^\s*[[:digit:]]+" | grep -Eo "[[:digit:]]+" | xargs -r kill -s QUIT'`
end
