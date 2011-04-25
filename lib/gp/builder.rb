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
    class << self
      private :new

      def build &blk
        return new(&blk).build
      end
    end
        
    def initialize &blk
      @functions = []
      @constants = {}
      @variables = {}

      instance_exec &blk
    end

    def build
      return Population.new @size, @functions, @constants, @variables, @return_type
    end

    def size value
      @size = value
    end

    def return_type value
      @return_type = value
    end

    def parse_file file
      yaml = YAML.parse_file file
      @functions += parse_functions yaml['functions'].value
      @constants.merge! parse_constants yaml['constants'].value
      @variables.merge! parse_variables yaml['variables'].value
    end
    private :parse_file

    def parse_functions s
      s.scan(FORMULA_REGEX).map do |name, args, type, code|
        name = name.to_sym
        args = args.scan(/\w+/).map(&:to_sym)
        type = type.to_sym
        Function.new name, args, type, code
      end
    end
    private :parse_functions

    def parse_constants h
      Hash[ h.map { |k, v| [k.value.to_sym, eval("proc { #{v.value} }")] } ]
    end
    private :parse_constants

    def parse_variables h
      Hash[ h.map { |k, v| [k.value, v.value.to_sym] } ]
    end
    private :parse_variables
  end
end
