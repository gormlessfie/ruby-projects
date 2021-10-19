# frozen_string_literal: true

#This initializes a random word to use from 5desk.txt, contain logic of guessing
class Board
  attr_reader :word

  def initialize(file_name)
    @file_name = file_name
    @word = random_word
  end

  private

  def random_word
    file = File.read(@file_name)

    word_list = file.downcase.split("\r\n")
    word_list = word_list.select { |word| word.length >= 5 && word.length <= 12}

    word_list.sample.split('')
  end
end
