# frozen_string_literal: true

dictionary = %w[
  below down go going horn how howdy it i
  low own part partner sit even evening
]
main_input = "Howdy partner, sit down! How's it going?"

def substrings(input, dictionary)
  split_input = input.downcase.split('').delete_if { |char| char.ord > 'z'.ord || char.ord < 'a'.ord }
  hash_count = match_characters(split_input, dictionary)
  puts hash_count
  hash_count
end

def match_characters(input, dictionary)
  matched_words = {}
  dictionary.each do |word|
    increment_count(word, matched_words, input)
  end
  matched_words.reject { |_key, value| value.zero? }
end

def increment_count(word, matched_words, input)
  matched_words[word.to_s] = 0
  split_word = word.split('')
  check_consecutive(word, input, split_word, matched_words)
  matched_words
end

def check_consecutive(word, input, split_word, matched_words)
  i = 0
  input.each do |index|
    if index == split_word[i]
      i += 1
      matched_words[word.to_s] += 1 if i == split_word.length
    else
      i = 0
    end
  end
  matched_words
end

substrings(main_input, dictionary)
