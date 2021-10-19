# frozen_string_literal: true

require 'yaml'
require './lib/player'
require './lib/board'

class Main
  attr_reader :word, :solution, :key, :key_word_count

  def initialize(dictionary_name)
    @player = Player.new()
    @key = Board.new(dictionary_name).word
    @solution = Array.new(@key.size) { '_' }
    @win = false
  end

  def menu
    print 'Would you like to load a saved game? [y/n]: '
    case gets.chomp.downcase
    when 'y'
      load_save
    when 'n'
      game_start
      puts "\n"
    else
      puts 'Invalid selection. Please try again.'
      menu
    end
  end

  def game_resume
    print_board
    game_loop
    choose_message
  end

  private

  def save_game
    save_name = Time.now.to_s
    serialized_object = YAML::dump(self)
    save_file = File.open("./saves/hangman-#{save_name}.yaml", 'w')
    save_file.puts serialized_object
    save_file.close
    puts 'Game saved. You can exit at any time.'
  end

  def load_save
    list_of_saves = Dir.new('./saves').children
    if list_of_saves.empty?
      puts 'Empty! There are no saves.'
      puts 'Starting new game!'
      puts "\n"

      game_start
    else
      print_saves_list(list_of_saves)
      input = clean_load_input(list_of_saves.size)
      file = File.open("./saves/#{list_of_saves[input]}", 'r')
      loaded_save = YAML::load(file)
      loaded_save.game_resume
    end
  end

  def clean_load_input(size)
    input = gets.chomp.to_i
    if input.between?(0, size - 1)
      input
    else
      puts "Invalid selection. Please choose from 0 - #{size - 1}"
      clean_load_input(size)
    end
  end

  def game_start
    intro_message
    print_board
    game_loop
    choose_message
  end

  def intro_message
    puts 'This is Hangman. You have to guess the word letter-by-letter.'
    puts 'You have 6 incorrect attempts to guess all the letters.'
    puts "Input '1' to save current game at any time."
    puts "\n"
  end

  def print_board
    puts "\n#{solution}"
    puts "Previous guesses: #{@player.previous_guesses}" if @player.previous_guesses.size > 0
  end

  def choose_message
    @win ? game_over_message('win') : game_over_message('lose')
  end

  def game_over_message(message)
    puts "You #{message}! The word was #{@key.join}. It took #{@player.previous_guesses.size} turns."
  end

  def print_saves_list(list_of_saves)
    list_of_saves.each_with_index { |file, idx| puts "[#{idx}] : #{file}" }
    print 'Enter the number that corresponds to the save: '
  end

  def player_turn
    check_guess(@player.make_guess)
    puts "Guesses remaining: #{@player.guess_attempts}"
  end

  def game_loop
    until @player.guess_attempts.zero? || @win
      player_turn
      print_board
      check_win
    end
  end

  def check_win
    @win = true if @solution == @key
  end

  def check_guess(player_guess)
    if player_guess == '1'
      save_game
    elsif correct_guess?(player_guess)
      update_solution(player_guess)
    else
      wrong_guess(player_guess)
    end
  end

  def update_solution(player_guess)
    @key.each_with_index do |value, idx|
      @solution[idx] = player_guess if value == player_guess
    end
  end

  def wrong_guess(player_guess)
    puts "\n"
    puts "Wrong guess. There are no #{player_guess}'s in the word."
    @player.decrement_guess_attempts
    puts "\n"
  end

  def correct_guess?(player_guess)
    @key.any?(player_guess) ? true : false
  end
end

main = Main.new('5desk.txt')

main.menu
