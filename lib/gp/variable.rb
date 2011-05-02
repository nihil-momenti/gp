require 'gp/node'

module GP
  class Variable < Node
    def initialize value, rtype
      super()
      @value = value
      @rtype = rtype
    end

    def to_s
      @value.to_s
    end

    def dup
      self.class.new @value, @rtype
    end

    def dup_with_replacement *args
      self.class.new @value, @rtype
    end
  end
end
