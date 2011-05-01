module GP
  class Algorithm
    attr_reader :functions, :constants, :variables, :return_type
    def initialize generation_type, depth
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
        self.class.variables.select{ |key, val| val == type }.map(&:first)
      else
        self.class.variables
      end
    end

    def functions type=nil
      if type != nil
        self.class.functions.select{ |func| func.type == type }
      else
        self.class.functions
      end
    end

    def constants
      self.class.constants
    end

    def __grow__ depth, type
      terminal_count = variables(type).length + 1
      function_count = functions(type).length

      if depth == 0 or rand < terminal_count / (terminal_count + function_count).to_f
        if rand < (1.0 / terminal_count)
          Constant.new constants[type].call
        else
          Variable.new "vars[:#{variables(type).choice}]"
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
          Constant.new constants[type].call
        else
          Variable.new "vars[:#{variables(type).choice}]"
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
      node
    end

    def cross other
      new_root = @root.dup
      last = new_root
      node = last.random_child
      while rand > 0.5 && node.has_children
        last = node
        node = node.random_child
      end
      last.replace(node, other.random_node)
      self.class.new nil, new_root
    end

    class << self
      attr_reader :functions, :constants, :variables, :return_type
    end
  end
end
