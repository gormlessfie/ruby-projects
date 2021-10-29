# frozen_string_literal: true

require './lib/node'
require 'pry-byebug'

# An implementation of binary search tree.
class Tree
  attr_reader :root

  def initialize(init_array)
    @root = build_tree(clean_array(init_array))
  end

  def clean_array(array)
    array.uniq.sort
  end

  def build_tree(array)
    return Node.new(array[0]) if array.size == 1

    return nil if array.empty?

    # find middle of array
    middle = array.size / 2

    @root = Node.new(array[middle], build_tree(array.slice(0, middle)),
                     build_tree(array.slice(middle + 1, array.size)))
    @root
  end

  def insert(value, current_node = @root)
    if value < current_node.data
      return current_node.left = Node.new(value) if current_node.left.nil?

      insert(value, current_node.left)
    else
      return current_node.right = Node.new(value) if current_node.right.nil?

      insert(value, current_node.right)
    end
  end

  def delete(value, previous_node = @root, current_node = @root)
    return if current_node.nil?
    return @root = nil if @root.data == value && @root.leaf_node?

    if value == current_node.data && current_node.leaf_node?
      return value > previous_node.data ? previous_node.right = nil : previous_node.left = nil
    elsif value == current_node.data && current_node.left && current_node.right
      min_right_node = current_node.right ? min_value(current_node.right) : min_value(current_node.left)

      delete(min_right_node.data)
      current_node_left = current_node.left
      current_node_right = current_node.right
      if value < previous_node.data
        previous_node.left = min_right_node
        min_right_node.left = current_node_left
        min_right_node.right = current_node_right
      elsif value > previous_node.data
        previous_node.right = min_right_node
        min_right_node.left = current_node_left
        min_right_node.right = current_node_right
      elsif value == current_node.data
        @root = min_right_node
        @root.left = current_node_left
        @root.right = current_node_right
      end
    elsif value > previous_node.data && value == current_node.data
      return previous_node.right = current_node.left if current_node.left

      return previous_node.right = current_node.right if current_node.right
    elsif value < previous_node.data && value == current_node.data
      return previous_node.left = current_node.left if current_node.left

      return previous_node.left = current_node.right if current_node.right
    end

    previous_node = current_node
    value < current_node.data ? delete(value, previous_node, current_node.left) : delete(value, previous_node, current_node.right)
  end

  def find(value, current_node = @root)
    return current_node if current_node.data == value

    if value < current_node.data
      return -1 if current_node.left.nil?

      find(value, current_node.left)
    else
      return -1 if current_node.right.nil?

      find(value, current_node.right)
    end
  end

  def level_order(current_node = @root, &block)
    return if current_node.nil?

    queue = []
    array = []
    queue.push(current_node)
    until queue.empty?
      current = queue.shift

      if block_given?
        block.call(current)
      else
        array.push(current_node.data)
      end

      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end
    return array unless block_given?
  end

  def level_order_recur(current_node = @root, queue = [], array = [], &block)
    return if current_node.nil?

    queue.push(current_node.left) if current_node.left
    queue.push(current_node.right) if current_node.right

    if block_given?
      block.call(current_node)
    else
      array.push(current_node.data)
    end

    level_order_recur(queue.shift, queue, array, &block)
    return array unless block_given?
  end

  # LEFT ROOT RIGHT
  def inorder(current_node = @root, array = [], &block)
    return if current_node.nil?

    inorder(current_node.left, array, &block)
    if block_given?
      block.call(current_node)
    else
      array.push(current_node.data)
    end
    inorder(current_node.right, array, &block)
    array
  end

  # ROOT LEFT RIGHT
  def preorder(current_node = @root, array = [], &block)
    return if current_node.nil?

    if block_given?
      block.call(current_node)
    else
      array.push(current_node.data)
    end
    preorder(current_node.left, array, &block)
    preorder(current_node.right, array, &block)
    array
  end

  #  LEFT RIGHT ROOT
  def postorder(current_node = @root, array = [], &block)
    return if current_node.nil?

    postorder(current_node.left, array, &block)
    postorder(current_node.right, array, &block)

    if block_given?
      block.call(current_node)
    else
      array.push(current_node.data)
    end
    array
  end

  def height(current_node = @root, most_height = 0)
    return 0 if current_node.left.nil? || current_node.right.nil?

    deepest_node = find_deepest_node(current_node)
    until current_node.data == deepest_node.data
      current_node = current_node.data < deepest_node.data ? current_node.right : current_node.left
      most_height += 1
    end
    most_height
  end

  def depth(target_node, root_node = @root, depth_value = 0)
    return -1 if target_node == -1
    return -1 if in_tree?(target_node)

    until root_node.data == target_node.data
      root_node = root_node.data < target_node.data ? root_node.right : root_node.left
      depth_value += 1
    end
    depth_value
  end

  def find_deepest_node(current_node = @root)
    deepest_node = nil
    level_order_recur(current_node) { |node| deepest_node = node }
    deepest_node
  end

  def balance?(current_node = @root)
    return if current_node.leaf_node?

    height_left = height(current_node.left)
    height_right = height(current_node.right)

    p "Current node: #{current_node.inspect}"
    puts "\n"
    p "left node: #{current_node.left.inspect}"
    p height_left
    puts "\n"
    p "right node: #{current_node.right.inspect}"
    p height_right

    return false if (height_left - height_right) > 1 || (height_right - height_left) > 1
  end

  def rebalance
    @root = build_tree(clean_array(inorder(@root)))
  end

  def min_value(current_node = @root)
    return current_node if current_node.left.nil?

    min_value(current_node.left)
  end

  def in_tree?(node)
    true unless find(node.data) == -1

    false
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

arr = [10, 20, 30, 40, 50]

tree = Tree.new(arr)
tree.insert(5)
tree.insert(3)
tree.insert(55)
tree.insert(21)
tree.insert(11)
tree.insert(6)
tree.insert(4)
tree.insert(41)
tree.insert(42)
tree.insert(43)
tree.pretty_print

tree.rebalance
tree.pretty_print

p tree.inorder
p tree.preorder
p tree.postorder
