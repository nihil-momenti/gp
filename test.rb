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
  size 64
  return_type :Number
  parse_file 'definitions.gp'
  fitness_function do |algo|
    examples.map do |test, result|
      (algo.call(test) - result).abs
    end.reduce(&:+)
  end
end

A = POP.instance_variable_get(:@pop).choice
B = POP.instance_variable_get(:@pop).choice
C = A.cross B


IRB.start(__FILE__)
