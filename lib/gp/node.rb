module GP
  class Node
    attr_reader :rtype

    def initialize children=[]
      @children = children
    end

    def traverse nodes=[], leaves=[]
      (has_children? ? nodes : leaves) << self
      @children.each { |child| child.traverse nodes, leaves }
      return nodes, leaves
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

    def simplify
      dup
    end

    def dup
      self.class.new @children.map { |child| child.dup }
    end

    def dup_with_replacement to_replace, replacement
      if self == to_replace
        replacement.dup
      else
        self.class.new @children.map { |child| child.dup_with_replacement to_replace, replacement }
      end
    end

    def random_child
      @children.choice
    end

    def has_children?
      @children.any?
    end
  end
end
