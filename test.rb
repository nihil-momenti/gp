require './lib/gp'
require 'irb'

examples = {
  {:x => 0.0, :y => 0.0} => 0.0,
  {:x => 1.0, :y => 0.0} => 1.0,
  {:x => 2.0, :y => 0.0} => 2.0,
  {:x => 0.0, :y => 1.0} => 1.0,
  {:x => 1.0, :y => 1.0} => 1.414,
  {:x => 2.0, :y => 1.0} => 2.236,
  {:x => 0.0, :y => 2.0} => 2.0,
  {:x => 1.0, :y => 2.0} => 2.236,
  {:x => 2.0, :y => 2.0} => 2.828
}

POP = GP::Builder.build do
  parse_file 'definitions.gp'

  pop_size 1000
  min_depth 2
  max_depth 16
  step_size 2
  return_type :Number

  fitness_function(proc do |algo|
    begin
      examples.map do |test, result|
        (algo.call(test) - result).abs
      end.reduce(&:+)
    rescue
      1000
    end
  end)
end

IRB.start(__FILE__)
