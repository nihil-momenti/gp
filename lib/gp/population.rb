module GP
  class Population
    attr_reader :pop

    def initialize pop=nil
      @pop = pop
      
      if @pop == nil
        @pop = []
        4.times.map do |x|
          ($environment.pop_size / 8).times do
            @pop << Algorithm.new(:grow, x + 2)
            @pop << Algorithm.new(:full, x + 2)
          end
        end
      end
    end

    def average_score
      @pop.reduce(0) do |sum, algo|
        sum += algo.score
      end / @pop.length
    end

    def lowest_score
      @pop.reduce([nil,100000]) do |sum, algo|
        if sum.last > algo.score
          [algo, algo.score]
        else
          sum
        end
      end
    end

    # Returns the entire tournament sorted best to worst.
    def tourney
      @pop.sample(($environment.pop_size**0.25).to_i).sort_by(&:score)
    end

    def succ
      new_pop = []

      ($environment.pop_size * $environment.crossover_rate).to_i.times { a,b = tourney ; new_pop << a.cross(b) }
      ($environment.pop_size * $environment.mutation_rate).to_i.times { a = tourney.first ; new_pop << a.mutate }
      ($environment.pop_size * $environment.reproduction_rate).to_i.times { a = tourney.first ; new_pop << a }
      ($environment.pop_size * $environment.simplification_rate).to_i.times { a = tourney.first ; new_pop << a.simplify }
      Population.new(new_pop)
    end
  end
end
