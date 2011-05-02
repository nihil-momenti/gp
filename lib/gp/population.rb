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
        puts environment.fitness_function.call(algo)
        puts
      end
    end

    def average_score
      @pop.reduce(0) do |sum, algo|
        sum += environment.fitness_function.call(algo)
      end / @pop.length
    end

    def highest_score
      @pop.reduce(1000) do |sum, algo|
        sum = [sum, environment.fitness_function.call(algo)].min
      end
    end

    def tourney
      (environment.size**0.5).to_i.times.map { @pop.choice }.map { |algo| [environment.fitness_function.call(algo), algo] }.sort_by(&:first)
    end

    def succ
      @pop = (@pop.length).times.map { a,b = tourney.pop 2 ; a.last.cross b.last }
    end
  end
end
