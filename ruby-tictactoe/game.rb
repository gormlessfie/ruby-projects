# frozen_string_literal: true

require './game_board'.freeze
require './player'.freeze

# Tic-Tac-Toe
class Game
  def initialize
  end

  def game_start
    game = Board.new
    player_one = Player.new('X')
    player_two = Player.new('O')
  
    until player_one.winner || player_two.winner || game.tie
      game.display_board
      game.place_on_board(player_one)
      game.det_winner(player_one)
  
      break if player_one.winner
      break if game.tie == true
  
      game.display_board
      game.place_on_board(player_two)
      game.det_winner(player_two)
    end
  
    game.display_board
    if player_one.winner
      puts "Game over! #{player_one.name} wins!"
    elsif player_two.winner
      puts "Game over! #{player_two.name} wins!"
    elsif game.tie == true
      puts 'Game over! Tie!' 
    end
  end
end

game = Game.new
game.game_start
