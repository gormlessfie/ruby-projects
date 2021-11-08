# frozen_string_literal: true

require './lib/game_board'.freeze
require './lib/player'.freeze

# Tic-Tac-Toe
class Game
  def initialize
    @game = Board.new
    @player_one = Player.new('X')
    @player_two = Player.new('O')
  end

  def game_start
    until @player_one.winner || @player_two.winner || @game.tie
      game_loop(@player_one)

      break if @player_one.winner
      break if @game.tie == true

      game_loop(@player_two)
    end
    game_over_screen
  end

  def game_loop(player)
    @game.display_board
    @game.place_on_board(player)
    @game.det_winner(player)
  end

  def game_over_screen
    @game.display_board
    if @player_one.winner
      puts "Game over! #{@player_one.name} wins!"
    elsif @player_two.winner
      puts "Game over! #{@player_two.name} wins!"
    elsif @game.tie == true
      puts 'Game over! Tie!'
    end
  end
end

game = Game.new
game.game_start
