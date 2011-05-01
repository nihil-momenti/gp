module GP
  class Population
    attr_reader :pop

    def initialize
      @pop = []

      functions = self.class.functions
      constants = self.class.constants
      variables = self.class.variables
      return_type = self.class.return_type

      puts functions, constants, variables, return_type

      a = Class.new(Algorithm) do
        @functions = functions
        @constants = constants
        @variables = variables
        @return_type = return_type
      end

      4.times do |x|
        (self.class.size / 8).times do
          @pop << a.new(:grow, x + 2)
          @pop << a.new(:full, x + 2)
        end
      end
    end

    def test
      @pop.map do |algo|
        puts '-----'
        puts algo
        puts self.class.fitness_function.call(algo)
        puts
      end
    end

    def average_score
      @pop.reduce(0) do |sum, algo|
        sum += self.class.fitness_function.call(algo)
      end / @pop.length
    end

    def highest_score
      @pop.reduce(1000) do |sum, algo|
        sum = [sum, self.class.fitness_function.call(algo)].min
      end
    end

    def tourney
      10.times.map { @pop.choice }.map { |algo| [self.class.fitness_function.call(algo), algo] }.sort_by(&:first)
    end

    def succ
      @pop = (@pop.length).times.map { a,b = tourney.pop 2 ; a.last.cross b.last }
    end

    class << self
      attr_reader :functions, :constants, :variables, :return_type, :fitness_function, :size
    end
  end
end
