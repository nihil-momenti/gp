require 'yaml'

require File.join File.dirname(__FILE__), 'function'

module GP
  name = /(\w+)/
  name_sep = /\s*:\s*/
  args = /((?:\s*\w+\s*,\s*)*\s*\w+)/
  type_sep = /\s*->\s*/
  type = /(\w+)/
  code_sep = /\s*=>\s*/
  code = /(\(.*\))/

  FORMULA_REGEX = /#{name}#{name_sep}#{args}#{type_sep}#{type}#{code_sep}#{code}/

  class Builder
    %w{
      pop_size max_depth min_depth step_size return_type fitness_function
    }.each do |attr|
      eval <<-END
        def #{attr.to_s} value
          @#{attr.to_s} = value
        end
      END
    end

    def initialize &blk
      @functions = []
      @aconstants = []
      @variables = []

      @pop_size = 100_000
      @min_depth = 2
      @max_depth = 8
      @step_size = 2

      instance_exec &blk
    end

    def build
      if @return_type == nil or @fitness_function == nil
        raise ArgumentError, "return_type and fitness_function required" 
      end

      environment = Environment.new(
        :functions => @functions,
        :aconstants => @aconstants,
        :variables => @variables,

        :pop_size => @pop_size,
        :min_depth => @min_depth,
        :max_depth => @max_depth,

        :return_type => @return_type,
        :fitness_function => @fitness_function
      )

      return Class.new(Population) { define_method(:environment) { environment } }.new
    end

    def parse_file file
      yaml = YAML.parse_file file
      @functions += parse_functions yaml['functions'].value
      @aconstants += parse_constants yaml['constants'].value
      @variables += parse_variables yaml['variables'].value
    end
    private :parse_file

    def parse_functions s
      s.scan(FORMULA_REGEX).map do |name, args, type, code|
        name = name.to_sym
        args = args.scan(/\w+/).map(&:to_sym)
        type = type.to_sym
        
        Class.new(Function) do
          @name = name
          @arg_types = args
          @rtype = type
          @code = code
        end
      end
    end
    private :parse_functions

    def parse_constants h
      h.map do |k, v| 
        Class.new(Constant) do
          @proc = eval("Proc.new { #{v.value} }")
          @rtype = k.value.to_sym
        end
      end
    end
    private :parse_constants

    def parse_variables h
      h.map do |k, v|
        Variable.new "vars[:#{k.value}]", v.value.to_sym
      end
    end
    private :parse_variables

    class << self
      private :new
      def build &blk
        return new(&blk).build
      end
    end
  end
end
