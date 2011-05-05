module GP
  class Algorithm
    attr_reader :functions, :aconstants, :variables, :return_type, :root
    def initialize generation_type, depth
      case generation_type
      when :grow
        @root = __grow__ depth, environment.return_type
      when :full
        @root = __full__ depth, environment.return_type
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
        environment.variables.select{ |var| var.rtype == type }
      else
        environment.variables
      end
    end

    def functions type=nil
      if type != nil
        environment.functions.select{ |func| func.rtype == type }
      else
        environment.functions
      end
    end

    def aconstants type=nil
      if type != nil
        environment.aconstants.select{ |const| const.rtype == type }
      else
        environment.aconstants
      end
    end

    def __grow__ depth, type
      terminal_count = variables(type).length + 1
      function_count = functions(type).length

      if depth == 0 or rand < terminal_count / (terminal_count + function_count).to_f
        if rand < (1.0 / terminal_count)
          aconstants(type).choice.new
        else
          variables(type).choice
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
          aconstants(type).choice.new
        else
          variables(type).choice
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

    def random_node type=nil
      if rand < 0.9 and @root.has_children?
        nodes, ignore = @root.traverse
      else
        ignore, nodes = @root.traverse
      end

      if type == nil
        nodes.choice
      else
        nodes.select { |node| node.rtype == type }.choice
      end
    end

    def cross other
      replacement = nil
      while replacement == nil
        to_replace = random_node
        replacement = other.random_node(to_replace.rtype)
      end
      self.class.new(nil, @root.dup_with_replacement(to_replace, replacement))
    end

    def mutate
      to_replace = random_node
      replacement = self.class.new(:grow, to_replace.max_height).root
      self.class.new(nil, @root.dup_with_replacement(to_replace, replacement))
    end

    def simplify
      self.class.new(nil, @root.simplify)
    end

    def score
      @score ||= environment.fitness_function.call(self)
    end

    class << self
      attr_reader :functions, :aconstants, :variables, :return_type
    end
  end
end
