# frozen_string_literal: true

#This will contain making guesses, previous guesses, and attempts left.
class Player
  attr_reader :previous_guesses, :guess_attempts

  def initialize
    @previous_guesses = []
    @guess_attempts = 6
  end

  def make_guess
    input = clean_input
    update_previous_guesses(input) unless input == '1'
    input
  end
  
  def decrement_guess_attempts
    @guess_attempts -= 1
  end

  private

  def update_previous_guesses(letter)
    @previous_guesses.push(letter)
  end

  def clean_input
    puts "\n"
    print 'Input a character: '
    input = gets.chomp.downcase

    if input.length == 1
      if @previous_guesses.include?(input)
        puts "You have already selected #{input}. Please select another letter."
        clean_input
      else
        input
      end
    else
      puts 'Invalid input, max length: 1'
      clean_input
    end
  end
end
