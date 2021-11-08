# frozen_string_literal: true

require './lib/player'.freeze

# The board for tic tac toe
class Board
  attr_reader :turns, :tie

  def initialize
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @turns = 0
    @tie = false
  end

  def place_on_board(player)
    player_value = player.make_selection
    if @board[(player_value[0] - 1)].instance_of?(Integer)
      player.win_value.push(player_value[0])
      @board[(player_value[0] - 1)] = player_value[1]
    else
      puts 'Spot taken, please try again.'
      display_board
      place_on_board(player)
    end
    @turns += 1
    @tie = true if @turns > 8
  end

  def display_board
    print "#{@board[0]} | #{@board[1]} | #{@board[2]}"
    puts ''
    print '--+---+--'
    puts ''
    print "#{@board[3]} | #{@board[4]} | #{@board[5]}"
    puts ''
    print '--+---+--'
    puts ''
    print "#{@board[6]} | #{@board[7]} | #{@board[8]}"
    puts ''
  end

  def det_winner(player)
    win_condition = [
      [1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9],
      [3, 5, 7], [1, 5, 9]
    ]
    win_condition.each do |win_array|
      if player.win_value.intersection(win_array).sort == win_array.sort
        player.win_value.intersection(win_array)
        player.winner = true
      end
    end
  end
end
