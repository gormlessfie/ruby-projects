# frozen_string_literal: true

# A node for a binary search tree. This takes in a value
# and points to nodes 1 level lower than current node
class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def leaf_node?
    return true if @left.nil? && @right.nil?

    false
  end
end
