require 'gp/node'

module GP
  class Constant < Node
    def initialize value=nil, rtype=nil
      super()
      @value = value!=nil ? value : self.class.proc.call
      @rtype = rtype || self.class.rtype
    end

    def constant?
      true
    end

    def to_s
      @value.inspect
    end
    
    def dup
      self.class.new @value
    end

    def dup_with_replacement to_replace, replacement
      if self == to_replace
        replacement.dup
      else
        self.class.new @value
      end
    end

    class << self
      attr_reader :proc, :rtype

      def inspect
        "#<GP::Constant:[#{@rtype}]>"
      end
    end
  end
end
