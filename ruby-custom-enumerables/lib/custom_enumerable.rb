# frozen_string_literal: true

# Adds custom enumerables recreating the Enumerable methods
module Enumerable
  def my_each
    return Enumerator.new(self) unless block_given?

    for i in 0...self.length
      yield self[i]
    end
  end

  def my_each_with_index
    for i in 0...self.length
      yield self[i], i if block_given?
    end
  end

  def my_select
    return Enumerator.new(self) unless block_given?

    arry = []
    self.my_each do |value|
      arry.push(value) if yield value
    end
    arry
  end

  def my_all?(pattern = nil)
    key_arry = self
    if pattern.nil?
      arry = self.my_select { |value| yield value } if block_given?
      arry = self.my_select { |value| value }
    else
      arry = self.my_select { |value| pattern === value }
    end
    key_arry == arry
  end

  def my_any?(pattern = nil)
    if pattern.nil?
      if block_given?
        arr = self.my_select { |value| yield value }
      else
        arr = self.my_select { |value| value }
      end
    else
      arr = self.my_select { |value| pattern === value }
    end
    unless arr.size.zero?
      true
    else
      false
    end
  end

  def my_none?(pattern = nil)
    if pattern.nil?
      if block_given?
        arry = self.my_select { |value| yield value }
      else
        arry = self.my_select { |value| value }
      end
    else
      arry = self.my_select { |value| pattern === value }
    end
    arry.size.zero?
  end

  def my_count(pattern = nil)
    if pattern.nil?
      if block_given?
        arry = self.my_select { |value| yield value}.size
      else
        arry = self.size
      end
    else
      arry = self.my_select { |value| pattern === value }.size
    end
    arry
  end

  def my_map(&block)
    return Enumerator.new(self) unless block_given?

    arry = []
    self.my_each do |value|
      arry.push(block.call(value))
    end
    arry
  end

  def my_inject(initial = self[0], sym_operator = nil)
    op = {
      '+': ->(x, y) { x + y },
      '-': ->(x, y) { x - y },
      '*': ->(x, y) { x * y },
      '/': ->(x, y) { x / y },
      '%': ->(x, y) { x % y }
    }

    if initial.is_a? Symbol
      sym_operator = initial
      initial = self[0]

      starting_location = initial == self[0] ? self.drop(1) : self
      starting_location.my_each do |value|
        initial = op[sym_operator].call(initial, value)
      end

    elsif sym_operator.nil? # no symbol
      raise LocalJumpError unless block_given? # error if no block , no symbol

      # this runs when no symbol, has block
      starting_location = initial == self[0] ? self.drop(1) : self
      starting_location.my_each do |value|
        initial = yield initial, value
      end
    end
    initial
  end
end

def multiply_els(array)
  array.my_inject(:*)
end

insane_block = proc { |value| puts value * 2 }

arr = [1, 2, 3, 4, 5]

# puts '---------------------'
# puts 'my_each vs. each'

# puts 'each'
# arr.each { |item| print item }

# puts "\n"

# puts 'my_each'
# arr.my_each { |value| print value }

# puts "\n"

# puts '---------------------'
# puts 'my_each_with_index vs. each_with_index'

# puts 'each_with_index'
# arr.each_with_index { |value, idx| puts "#{idx}: #{value}" }

# puts "\n"

# puts 'my_each_with_index'
# arr.my_each_with_index { |value, idx| puts "#{idx}: #{value}" }

# puts '---------------------'
# puts 'my_each_with_index vs. each_with_index'

# puts 'select'
# puts arr.select { |value| value.even? }

# puts "\n"

# puts 'my_select'
# puts arr.my_select { |value| value.even? }

# puts '---------------------'
# puts 'my_all? vs. all?'

# puts 'all?'
# puts arr.all?

# puts "\n"

# puts 'my_all?'
# puts arr.my_all?

# puts '---------------------'
# puts 'my_any? vs. any?'

# puts 'any?'
# puts arr.any? { |value| value > 1 }

# puts "\n"

# puts 'my_any?'
# puts arr.my_any? { |value| value > 1 }

# puts '---------------------'
# puts 'none? vs. my_none?'

# puts 'none?'
# puts arr.none?

# puts "\n"

# puts 'my_none?'
# puts arr.my_none?

# puts '---------------------'
# puts 'count vs. my_count'

# puts 'count'
# puts arr.count { |value| value > 10}

# puts "\n"

# puts 'my_count'
# puts arr.my_count { |value| value > 10}

# puts '---------------------'
# puts 'map vs. my_map'

# puts 'map'
# puts arr.map { |value| value * 2 }

# puts "\n"

# puts 'my_map'
# puts arr.my_map { |value| value * 2 }

# puts '---------------------'
# puts 'inject vs. my_inject'

# puts 'inject'
# puts arr.inject(:-)

# puts "\n"

# puts 'my_inject'
# puts arr.my_inject(:-)

# puts '---------------------'
# puts 'testing my_inject'

# puts 'inject'
# puts [2, 4, 5].inject(:*)

# puts "\n"

# puts 'multiply_els'
# puts multiply_els([2, 4, 5])

# puts '---------------------'
# puts 'my_map with proc'

# puts 'map'
# puts arr.map(&insane_block)

# puts "\n"

# puts 'my_map'
# puts arr.my_map(&insane_block)

def tester(array, &block)
  block.call(array)
end

