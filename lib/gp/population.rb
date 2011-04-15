module GP
  class Population
    attr_reader :pop

    def initialize size, functions, constants, variables, return_type
      @pop = []
      4.times do |x|
        (size / 8).times do
          @pop << Algorithm.new(functions, constants, variables, return_type, :grow, x + 2)
          @pop << Algorithm.new(functions, constants, variables, return_type, :full, x + 2)
        end
      end
    end
  end
end
