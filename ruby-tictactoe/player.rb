# frozen_string_literal: true

# The user in tic tac toe
class Player
  attr_accessor :winner, :win_value
  attr_reader :name

  VALID_SELECTION = [1...9].freeze

  def initialize(name)
    @name = name
    @winner = false
    @win_value = []
  end

  def make_selection
    print "It's #{@name}'s turn! Please choose a selection: "
    input = gets.chomp.to_i
    if input.between?(1, 9)
      [input, @name]
    else
      puts 'Invalid selection, try again.'
      make_selection
    end
  end
end
