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
        puts algo.score
        puts
      end
    end

    def average_score
      @pop.reduce(0) do |sum, algo|
        sum += algo.score
      end / @pop.length
    end

    def highest_score
      @pop.reduce(1000) do |sum, algo|
        if algo.score == 0
          puts "WINNER: #{algo}"
        end
        sum = [sum, algo.score].min
      end
    end

    # Returns the entire tournament sorted best to worst.
    def tourney
      (environment.pop_size**0.25).to_i.times.map { @pop.choice }.sort_by { |algo| algo.score }
    end

    def succ
      @pop = (@pop.length).times.map { a,b = tourney ; a.cross b }
      self
    end
  end
end
