require 'gp/node'

module GP
  class Variable < Node
    def initialize value, rtype
      super()
      @value = value
      @rtype = rtype
    end

    def constant?
      false
    end

    def to_s
      @value.to_s
    end

    def dup
      self.class.new @value, @rtype
    end

    def dup_with_replacement to_replace, replacement
      if self == to_replace
        replacement.dup
      else
        self.class.new @value, @rtype
      end
    end
  end
end
