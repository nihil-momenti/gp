require 'gp/node'

module GP
  class Variable < Node
    def initialize value
      @value = value
    end

    def to_s
      @value.to_s
    end
  end
end
