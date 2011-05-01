require 'gp/node'

module GP
  class Variable < Node
    def initialize value
      super()
      @value = value
    end

    def to_s
      @value.to_s
    end

    def dup
      self
    end
  end
end
