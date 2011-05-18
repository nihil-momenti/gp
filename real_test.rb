require 'pp'
require './lib/gp'
%w{
  training
  validation
}.each {|set| require "./data/#{set}.set" }
#require 'irb'

GP::Builder.load do
  parse_file 'data/definitions.gp'

  pop_size 1000
  min_depth 2
  max_depth 16
  step_size 2
  return_type :CoverType

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

pop = $environment.build

#IRB.start(__FILE__)

while pop.lowest_score.last > 0.5
  puts "Current scores:"
  puts "  Average: #{pop.average_score}"
  algo, score = pop.lowest_score
  puts "  Lowest:  #{score}"
  puts "Best algo: #{algo}"
  pop = pop.succ
end

algo, score = pop.lowest_score
puts "===="
puts "WINNER:"
puts "  score: #{score}"
puts "  algo: #{algo}"
puts "  simplified: #{algo.simplify}"
