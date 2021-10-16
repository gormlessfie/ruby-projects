# frozen_string_literal: true

require './player'
require './computer'

# Game contains logic for game rounds and player actions
class Game
  def initialize(player_one, player_two)
    @player_one = player_one
    @player_two = player_two
    @game_over = false
    @round = 1
  end

  def menu
    puts "This is the game Mastermind.\nPlay against a computer? [y/n]"
    case gets.chomp
    when 'y'
      game_start(false)
    when 'n'
      game_start(true)
    else
      puts 'Invalid choice.'
      menu
    end
  end

  private

  def game_start(human)
    game_setup(human)
    play_round until @game_over || @round == 12
    print_game_over
    play_again
  end

  def game_setup(human)
    if human
      print_human_intro
      @player_two.choose_code('secret', 'secret')
      puts 'It is now the code-breaker\'s turn.'
    else
      print_intro
      computer_play(@player_two)
    end
  end

  def play_round
    puts "Round #{@round}"
    player_play(@player_one)
    check_win
    provide_hints
    @player_one.reset_player_guess
    @round += 1
  end

  def player_play(player)
    player.choose_code('guess', 'guess')
  end

  def computer_play(player)
    player.assign_secret_codes
  end

  def play_again
    return unless gets.chomp == 'Y'

    @player_one = Player.new
    @player_two = Computer.new
    @game_over = false
    menu
  end

  def print_intro
    puts "\n"
    puts 'The computer has chosen 4 colors and you must guess the color and position.'
    puts "\n"
    rules_explanation
  end

  def rules_explanation
    puts 'You have 12 rounds to guess the opponent\'s secret code.'
    puts 'You will also get 4 hint pegs about the opponent\'s secret code.'
    puts 'A black peg signals correct location and color.'
    puts 'A white peg signals correct color but incorrect location.'
    puts 'A missing peg signals incorrect location and color'
    puts "\n"
  end

  def print_human_intro
    puts "\n"
    puts 'You are the code-maker and the opponent is the code-breaker.'
    puts "\n"
    rules_explanation
  end

  def print_game_over
    puts @game_over ? 'You win! You have guessed all of the correct pegs' :
                      'You lose! You ran out of turns.'
    puts 'Play again? [y/n]'
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
mastermind = Game.new(Player.new, Computer.new)
mastermind.menu
