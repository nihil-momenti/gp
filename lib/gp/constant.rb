require 'gp/node'

module GP
  class Constant < Node
    def initialize value=nil
      super()
      @value = value || self.class.proc.call
      @rtype = self.class.rtype
    end

    def to_s
      @value.to_s
    end
    
    def dup
      self.class.new @value
    end

    def dup_with_replacement *args
      self.class.new @value
    end

    class << self
      attr_reader :proc, :rtype
    end
  end
end
