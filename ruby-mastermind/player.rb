# frozen_string_literal: true

require './mastermind_helper'
require './peg'

# This keeps track of the user's score and player.
class Player
  include MasterMindHelper
  attr_accessor :secret_code, :score, :guess
  attr_reader :name

  def initialize
    @secret_code = []
    @guess = []
    @score = 0
  end

  def choose_code(code_array, location)
    show_possible_colors
    case code_array
    when 'secret'
      4.times { @secret_code.push(Peg.new(filter_input(location))) }
    when 'guess'
      4.times { @guess.push(Peg.new(filter_input(location))) }
    end
  end

  def send_peg_info(code_array)
    colors = []
    case code_array
    when 'secret'
      secret_code.each { |value| colors.push(value.color) }
    when 'guess'
      guess.each { |value| colors.push(value.color) }
    end
    colors
  end

  def choose_guess
    choose_code('guess', 'guess')
  end

  def reset_player_guess
    @guess.clear
  end

  def reset_player_secret
    @secret_code.clear
  end

  private

  def show_possible_colors
    print "#{POSSIBLE_COLORS}\n"
  end

  def ask_for_input(location)
    print "Choose four colors for your #{location}. (assigns from left to right): "
  end

  def filter_input(location)
    ask_for_input(location)
    input = gets.chomp
    if POSSIBLE_COLORS.include?(input)
      input
    else
      puts 'Invalid selection. Please choose from these predetermined colors: '
      print "#{POSSIBLE_COLORS}\n"
      filter_input(location)
    end
  end
end
