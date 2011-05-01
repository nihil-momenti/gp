module GP
  class Algorithm
    attr_reader :functions, :constants, :variables, :return_type
    def initialize functions, constants, variables, return_type, generation_type, depth
      @functions = functions
      @constants = constants
      @variables = variables
      @return_type = return_type

      case generation_type
      when :grow
        @root = __grow__ depth, return_type
      when :full
        @root = __full__ depth, return_type
      else
        @root = depth
      end

      eval <<-END
        class << self
          def call vars
            #{ @root.to_s }
          end
        end
      END
    end

    def variables type=nil
      if type != nil
        @variables.select{ |key, val| val == type }.map(&:first)
      else
        @variables
      end
    end

    def functions type=nil
      if type != nil
        @functions.select{ |func| func.type == type }
      else
        @functions
      end
    end

    def constants
      @constants
    end

    def __grow__ depth, type
      terminal_count = variables(type).length + 1
      function_count = functions(type).length

      if depth == 0 or rand < terminal_count / (terminal_count + function_count).to_f
        if rand < (1.0 / terminal_count)
          constants[type].call
        else
          "vars[:#{variables(type).choice}]"
        end
      else
        func = functions(type).choice
        raise RuntimeError, "no functions with return type [#{type}]" if func == nil
        func.new func.arg_types.map { |type| __grow__ depth - 1, type }
      end
    end
    private :__grow__

    def __full__ depth, type
      if depth == 0
        var_num = variables(type).length
        if rand < (1.0 / (var_num + 1))
          constants[type].call
        else
          "vars[:#{variables(type).choice}]"
        end
      else
        func = functions(type).choice
        raise RuntimeError, "no functions with return type [#{type}]" if func == nil
        func.new func.arg_types.map { |type| __full__ depth - 1, type }
      end
    end
    private :__full__

    def inspect
      @root.inspect
    end

    def to_s
      @root.to_s
    end

    def random_node
      node = @root
      while rand > 0.5 && node.has_children
        node = node.random_child
      end
    end

    def cross other
      last = @root
      node = last.random_child
      while rand > 0.5 && node.has_children
        last = node
        node = node.random_child
      end
      last.replace(node, other.random_node)
    end
  end
end
