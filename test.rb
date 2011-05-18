require './lib/gp'
#require 'irb'

GP::Builder.load do
  parse_file 'definitions.gp'

  pop_size 1000
  min_depth 2
  max_depth 16
  step_size 2
  return_type :Number

  fitness_function proc { |algo|
    begin
      10.times.map do |x|
        10.times.map do |y|
          vars = { :x => x, :y => y }
          result = (x*x + y*y).to_f
          (algo.call(vars) - result).abs / (result == 0 ? 1.0 : result)
        end.reduce(&:+)
      end.reduce(&:+) + 0.1 * algo.root.avg_height
    rescue
      puts $!
      1000
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
