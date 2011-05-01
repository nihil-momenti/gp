module GP
  class Node
    def initialize
      @children = []
    end

    def random_child
      @children.choice
    end

    def has_children
      @children.any?
    end
  end
end
