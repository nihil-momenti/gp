module GP
  class Function
    attr_reader :name, :arg_types, :type, :code

    def initialize name, arg_types, type, code
      @name = name
      @arg_types = arg_types
      @type = type
      @code = code
      
      @klass = Class.new do
        attr_reader :args

        def initialize args
          @args = args
        end
      end

      @klass.class_eval <<-END
        def to_s
          #{ code.inspect.gsub(/\{(\d*)\}/, '#{ args[\1] }') }
        end

        def inspect
          #{ code.inspect.gsub(/\{(\d*)\}/, '#{ args[\1] }') }
        end
      END
    end

    def new *args
      @klass.new *args
    end

    def to_s
      <<-END
#{ name }: #{ arg_types * ', ' } -> #{ type }
 => #{ code }
      END
    end

    def inspect
      "#<GP::Function:[#{ name }:#{ arg_types * ',' }->#{ type }=>#{ code }]>"
    end
  end
end
