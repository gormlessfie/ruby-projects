# frozen_string_literal: true

# The user in tic tac toe
class Player
  attr_accessor :winner, :win_value
  attr_reader :name

  def initialize(name)
    @name = name
    @winner = false
    @win_value = []
  end

  def make_selection
    print "It's #{@name}'s turn! Please choose a selection: "
    verify_input
  end

  def verify_input
    loop do
      input = gets.chomp.to_i
      return [input, @name] if input.between?(1, 9)

      puts 'Invalid selection, try again.'
    end
  end
end
