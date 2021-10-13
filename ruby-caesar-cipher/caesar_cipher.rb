# frozen_string_literal: true

def caesar_cipher(string, shift_factor)
  split_string = string.split('').map do |value|
    determine_value(value, shift_factor)
  end
  p split_string.join
end

def determine_value(value, shift_factor)
  if value.ord.between?(65, 90)
    shift_value(value, shift_factor, 65)
  elsif value.ord.between?(97, 122)
    shift_value(value, shift_factor, 97)
  else
    value
  end
end

def shift_value(value, shift_factor, starting_code)
  aligned_num = return_shifted_code(value.ord, starting_code)
  shifted_val = (aligned_num + shift_factor) % 26
  (shifted_val + starting_code).chr
end

def return_shifted_code(value, mod_by)
  value % mod_by
end

caesar_cipher('a to z !!! 123', 0)
