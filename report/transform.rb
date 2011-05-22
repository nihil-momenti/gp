#!/usr/bin/env ruby

at_end = false

while gets
  case $_
  when /\\begin\{quote\}\\begin\{lstlisting\}/
    puts "\\begin{lstlisting}"
  when /\\end\{lstlisting\}/
    puts $_
    at_end = true
  when /\\end\{quote\}/
    puts $_ unless at_end
    at_end = false
  when /\\author\{\}/
    nil
  when /\\noindent\\makebox\[\\textwidth\]\[c\]\{(.*)\}/
    puts "\\centering#{$1}"
  when /FULLWIDTH/
    while gets
      case $_
      when /\\noindent\\makebox\[\\textwidth\]\[c\]\{(.*)\}/
        puts "\\centering#{$1}"
      when /\\begin\{figure\}/
        puts "\\begin{figure*}"
      when /\\end\{figure\}/
        puts "\\end{figure*}"
        break
      else
        puts $_
      end
    end
  else
    puts $_
  end
end
