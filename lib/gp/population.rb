module GP
  class Population
    attr_reader :pop

    def initialize
      @pop = []

      temp = environment()
      a = Class.new(Algorithm) { define_method(:environment) { temp } }

      4.times do |x|
        (environment.pop_size / 8).times do
          @pop << a.new(:grow, x + 2)
          @pop << a.new(:full, x + 2)
        end
      end
    end

    def test
      @pop.map do |algo|
        puts '-----'
        puts algo
        puts algo.score(&environment.fitness_function)
        puts
      end
    end

    def average_score
      @pop.reduce(0) do |sum, algo|
        sum += algo.score(&environment.fitness_function)
      end / @pop.length
    end

    def highest_score
      @pop.reduce(1000) do |sum, algo|
        sum = [sum, algo.score(&environment.fitness_function)].min
      end
    end

    def tourney
      (environment.pop_size**0.5).to_i.times.map { @pop.choice }.map { |algo| [algo.score(&environment.fitness_function), algo] }.sort_by(&:first)
    end

    def succ
      @pop = (@pop.length).times.map { a,b = tourney ; a.last.cross b.last }
      self
    end
  end
end
