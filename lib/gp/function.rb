require 'gp/node'

module GP
  class FunctionDefinition
    attr_reader :rtype, :arg_types, :code

    def initialize name, args, type, code
      @name = name
      @arg_types = args
      @rtype = type
      @code = code
    end

    def new children
      Function.new(children, self)
    end

    def to_s
      <<-END
#{ @name }: #{ @arg_types.join(', ') } -> #{ @rtype }
 => #{ @code }
      END
    end

    def inspect
      "#<GP::FunctionDefinition:[#{ @name }:#{ @arg_types.join(',') }->#{ @rtype }=>#{ @code }]>"
    end
  end

  class Function < Node
    def initialize children, definition
      super(children)
      @rtype = definition.rtype
      @definition = definition
    end
        
    def to_s
      @code ||= @definition.code.gsub(/\{\d*\}/) { |s| @children[s.delete('{}').to_i].to_s }
    end

    def inspect
      @code ||= @definition.code.gsub(/\{\d*\}/) { |s| @children[s.delete('{}').to_i].to_s }
    end

    def constant?
      @children.all? { |child| child.constant? }
    end

    def simplify
      if constant?
        Constant.new(eval(self.to_s), self.rtype)
      else
        @definition.new @children.map { |child| child.simplify }
      end
    end

    def dup
      self.class.new @children.map { |child| child.dup }, @definition
    end

    def dup_with_replacement to_replace, replacement
      if self == to_replace
        replacement.dup
      else
        self.class.new @children.map { |child| child.dup_with_replacement to_replace, replacement }, @definition
      end
    end

  end
end
