# frozen_string_literal: true

require './player'
require './computer'

# Game contains logic for game rounds and player actions
class Game
  def initialize(player_one, player_two)
    @player_one = player_one
    @player_two = player_two
    @game_over = false
  end

  def game_start
    print_intro
    computer_play(@player_two)

    until @game_over
      play_round
      provide_hints
      @player_one.reset_player_guess
    end

    print_game_over
  end

  def play_round
    p @player_two.send_peg_info('secret')
    player_play(@player_one)
    check_win
  end

  def player_play(player)
    player.choose_code('guess', 'guess')
  end

  def computer_play(player)
    player.assign_secret_codes
  end

  private

  def print_intro
    puts "\n"
    puts 'This is the game Mastermind. The computer has chosen 4 colors and ' \
         'you must guess the color and position.'
    puts 'For every round an incorrect guess is made, the opponent will gain a point.'
    puts 'You will also get 4 hint pegs about the opponent\'s secret code.'
    puts 'A black peg signals correct location and color.'
    puts 'A white peg signals correct color but incorrect location.'
    puts 'A missing peg signals incorrect location and color'
    puts "\n\n"
  end

  def print_game_over
    puts 'You win! You have guessed all of the correct pegs'
  end

  def check_win
    @game_over = true if @player_one.send_peg_info('guess') == @player_two.send_peg_info('secret')
  end

  def provide_hints
    black_pegs = 0
    white_pegs = Hash.new(0)
    white_pegs_count = 0
    @player_one.send_peg_info('guess').each do |guess_element|
      white_pegs[guess_element] += 1 if @player_two.send_peg_info('secret').any?(guess_element)
    end
    @player_one.send_peg_info('guess').each_with_index do |guess_element, idx|
      if guess_element == @player_two.send_peg_info('secret')[idx]
        black_pegs += 1
        white_pegs[guess_element] -= 1
      end
    end
    white_pegs.each_value { |value| white_pegs_count += value }
    puts "There are #{black_pegs} black pegs and #{white_pegs_count} white pegs."
  end

  def check_colors
    color_match = @player_one.send_peg_info('guess').intersection(@player_two.send_peg_info('secret'))
    puts "There are #{color_match.size} white pegs."
  end
end

mastermind = Game.new(Player.new('billy'), Computer.new('computer'))

mastermind.game_start
