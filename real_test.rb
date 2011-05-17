require 'pp'
require './lib/gp'
%w{
  training
  validation
}.each {|set| p set;require "./data/#{set}.set" }
#require 'irb'

puts "building"
POP = GP::Builder.build do
  parse_file 'data/definitions.gp'

  pop_size 1000
  min_depth 2
  max_depth 16
  step_size 2
  return_type :CoverType

  pp @aconstants
  pp @variables
  pp @functions

  fitness_function proc { |algo|
    begin
      Assignment::Data::Training.map do |example|
        algo.call(example) == example[:cover_type] ? 0 : 1
      end.reduce(&:+) + 0.1 * algo.root.avg_height
    rescue
      puts $!
      100000
    end
  }
end


#IRB.start(__FILE__)

while POP.highest_score.last > 0.5
  puts "Current scores:"
  puts "  Average: #{POP.average_score}"
  algo, score = POP.highest_score
  puts "  Lowest:  #{score}"
  puts "Best algo: #{algo}"
  POP.succ
end

algo, score = POP.highest_score
puts "===="
puts "WINNER:"
puts "  score: #{score}"
puts "  algo: #{algo}"
puts "  simplified: #{algo.simplify}"
