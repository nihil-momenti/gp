require 'yaml'

require File.join File.dirname(__FILE__), 'function'

module GP
  name = /(\w+)/
  name_sep = /\s*:\s*/
  normal_type = /[\w_]+/
  generic_type = /<#{normal_type}>/
  type = /#{normal_type}|#{generic_type}/
  args = /((?:\s*#{type}\s*,\s*)*\s*#{type})/
  type_sep = /\s*->\s*/
  return_type = /(#{type})/
  code_sep = /\s*=>\s*/
  code = /(\(.*\))/

  FORMULA_REGEX = /#{name}#{name_sep}#{args}#{type_sep}#{return_type}#{code_sep}#{code}/
  TYPE_REGEX = type
  NORMAL_TYPE_REGEX = normal_type
  GENERIC_TYPE_REGEX = generic_type

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

      @crossover_rate = 0.9
      @mutation_rate = 0.02
      @reproduction_rate = 0.04
      @simplification_rate = 0.04

      @step_size = 2

      instance_exec &blk
    end

    def load
      if @return_type == nil or @fitness_function == nil
        raise ArgumentError, "return_type and fitness_function required" 
      end

      $environment = Environment.new(
        :functions => @functions,
        :aconstants => @aconstants,
        :variables => @variables,

        :pop_size => @pop_size,
        :min_depth => @min_depth,
        :max_depth => @max_depth,

        :crossover_rate => @crossover_rate,
        :mutation_rate => @mutation_rate,
        :reproduction_rate => @reproduction_rate,
        :simplification_rate => @simplification_rate,

        :return_type => @return_type,
        :fitness_function => @fitness_function
      )
    end

    def parse_file file
      yaml = YAML.parse_file file
      @aconstants += parse_constants yaml['constants'].value
      @functions += parse_functions yaml['functions'].value
      @variables += parse_variables yaml['variables'].value
    end
    private :parse_file

    def replace_generic args
      return enum_for(:replace_generic) unless block_given?
      to_replace = args.select { |arg| GENERIC_TYPE_REGEX =~ arg }.first
      deeper = args.any? { |arg| (arg != to_replace) and (GENERIC_TYPE_REGEX =~ arg) }
      @aconstants.each do |replacement|
        new_args = args.map{ |arg| arg == to_replace ? replacement.rtype.to_s : arg }
        if deeper
          replace_generic(new_args) do |new_new_args|
            yield new_new_args
          end
        else
          yield new_args
        end
      end
    end

    def parse_functions s
      s.scan(FORMULA_REGEX).map do |name, args, type, code|
        name = name.to_sym
        args = args.scan(TYPE_REGEX)
        
        if args.any? { |arg| GENERIC_TYPE_REGEX =~ arg }
          a = []
          replace_generic(args+[type]) do |new_args|
            new_type = new_args.pop
            a << FunctionDefinition.new(name, new_args.map(&:to_sym), new_type.to_sym, code)
          end
          a
        else
          FunctionDefinition.new(name, args.map(&:to_sym), type.to_sym, code)
        end
      end.flatten
    end
    private :parse_functions

    def parse_constants h
      h.map do |k, v| 
        ConstantType.new(v.value, k.value.to_sym)
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
      def load &blk
        return new(&blk).load
      end
    end
  end
end
