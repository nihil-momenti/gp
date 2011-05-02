module GP
  class Node
    attr_reader :rtype

    def initialize children=[]
      @children = children
    end

    def traverse
      @children.map { |child| child.traverse }.flatten << self
    end

    def max_height
      @max_height ||= if has_children?
        @children.map { |child| child.max_height }.max + 1
      else
        1
      end
    end

    def avg_height
      @avg_height ||= if has_children?
        @children.map { |child| child.avg_height }.reduce(&:+) / @children.size + 1
      else
        1
      end
    end

    def dup
      self.class.new @children.map { |child| child.dup }
    end

    def dup_with_replacement to_replace, replacement
      if @children.include? to_replace
        self.class.new @children.map do |child|
          child == to_replace ? replacement.dup : child.dup
        end
      else
        self.class.new @children.map do |child|
          child.dup_with_replacement to_replace, replacement
        end
      end
    end

    def random_child
      @children.choice
    end

    def has_children
      @children.any?
    end
  end
end
