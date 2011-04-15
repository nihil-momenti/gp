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

  class << self
    def parse_file file
      yaml = YAML.parse_file file
      functions = parse_formulas yaml['functions']
    end

    def parse_formulas s
      s.scan(FORMULA_REGEX).map do |name, args, type, code|
        name = name.to_sym
        args = args.scan(/\w+/).map(&:to_sym)
        type = type.to_sym
        Function.new name, args, type, code
      end
    end
  end
end
