module GP
  class Environment
    def initialize args
      @args = args
    end

    def build
      Population.new
    end

    def method_missing method, *args, &blk
      return @args[method] if @args.include? method
      super
    end

    def respond_to? method
      return @args.include? method
    end
  end
end
