module GP
  class Environment
    def initialize args
      self.class.instance_exec do
        args.each do |key, value|
          define_method(key) do
            value
          end
        end
      end
    end
  end
end
