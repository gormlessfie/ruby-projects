# frozen_string_literal: true

require './lib/node'

# A linked list implementation in Ruby. This holds a list of nodes.
class LinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
    @@size = 0
  end

  def append(value)
    if @head.nil?
      @head = Node.new(value)
      @tail = @head
    else
      # Place new node at the end which links to the previous end the list node
      @tail.pointer = Node.new(value)
      @tail = @tail.pointer
    end
    increment_size
  end

  def prepend(value)
    if @head.nil?
      @head = Node.new(value)
      @tail = @head
    else
      old_head = @head
      new_head = Node.new(value, old_head)
      @head = new_head
    end
    increment_size
  end

  def size
    @@size
  end

  def at(index)
    current_node = @head
    index.times do
      current_node = current_node.next_node
    end
    current_node
  end

  def pop
    current_node = @head
    @head = nil if size == 1
    (size - 2).times do
      current_node = current_node.next_node
    end
    current_node.pointer = nil
    @tail = current_node

    decrement_size
  end

  def contains?(value)
    current_node = @head

    (size - 1).times do
      return true if current_node.value == value

      current_node = current_node.next_node
    end

    false
  end

  def find(value)
    current_node = @head

    size.times do |i|
      return i if current_node.value == value

      current_node = current_node.next_node
    end
    -1
  end

  def to_s
    current_node = @head
    size.times do
      print "( #{current_node.value.to_s} ) -> "
      current_node = current_node.next_node
    end
    print 'nil'
    puts "\n"
  end

  def insert_at(value, index)
    @head = Node.new(value) if size.zero?

    before_node = at(index)
    after_node = at(index + 1)
    insert_node = Node.new(value, after_node)
    before_node.pointer = insert_node
    increment_size
  end

  def remove_at(index)
    after_node = at(index + 1)
    # remove node at current index, set node before to node after current index
    if index.zero?
      @head = after_node
    else
      before_node = at(index - 1)
      before_node.pointer = after_node
    end

    decrement_size
  end

  def increment_size
    @@size += 1
  end

  def decrement_size
    @@size -= 1
  end
end
