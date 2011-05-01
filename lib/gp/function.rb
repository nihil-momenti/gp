require 'gp/node'

module GP
  class Function < Node
    def initialize args
      @children = args
    end
        
    def to_s
      @code ||= self.class.code.gsub(/\{\d*\}/) { |s| @children[s.delete('{}').to_i].to_s }
    end

    def inspect
      @code ||= self.class.code.gsub(/\{\d*\}/) { |s| @children[s.delete('{}').to_i].to_s }
    end

    class << self
      attr_reader :name, :arg_types, :type, :code

      def to_s
        <<-END
#{ @name }: #{ @arg_types.join(', ') } -> #{ @type }
 => #{ @code }
        END
      end

      def inspect
        "#<GP::Function:[#{ @name }:#{ @arg_types.join(',') }->#{ @type }=>#{ @code }]>"
      end
    end
  end
end
