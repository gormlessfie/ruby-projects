# frozen_string_literal: true

# A node that has data and a pointer that points to another node.
class Node
  attr_accessor :value, :pointer
  
  def initialize(value = nil, pointer = nil)
    @value = value
    @pointer = pointer
  end

  def next_node
    @pointer
  end
end
