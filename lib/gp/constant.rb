require 'gp/node'

module GP
  class ConstantType
    attr_reader :proc, :rtype

    def initialize prok, type
      @proc = prok
      @rtype = type
    end

    def new value=nil, rtype=nil
      if value
        Constant.new value, @rtype
      else
        Constant.new eval(@proc), @rtype
      end
    end

    def inspect
      "#<GP::Constant:[#{@rtype}]>"
    end
  end

  class Constant < Node
    def initialize value, rtype
      super()
      @value = value
      @rtype = rtype
    end

    def constant?
      true
    end

    def to_s
      @value.inspect
    end
    
    def dup
      Constant.new @value, @rtype
    end

    def dup_with_replacement to_replace, replacement
      if self == to_replace
        replacement.dup
      else
        Constant.new @value, @rtype
      end
    end
  end
end
