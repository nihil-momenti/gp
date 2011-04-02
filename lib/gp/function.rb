module GP
  class Function
    attr_reader :name, :type, :arg_types

    def initialize name, args
      @name = name
      @type = args[:type]
      @arg_types = args[:args]
      
      @klass = Class.new do
        attr_reader :args

        def initialize args
          @args = args
        end
      end

      @klass.class_eval <<-END
        def to_s
          #{ args[:code] }
        end

        def inspect
          "#{ @type } <- #{ @name }(#{ @arg_types.join ', ' })\n{\n\#{ @args.map(&:inspect).join ",\n"}\n}"
        end
      END
    end

    def new *args
      @klass.new *args
    end
  end
end
