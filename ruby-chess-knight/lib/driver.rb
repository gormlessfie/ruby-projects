# frozen_string_literal: true

require './lib/knight'

knight = Knight.new

puts 'Chess board'
knight.print_chess_board

puts "\n\n"

puts 'List of Possible moves per square'
knight.print_legal_moves

puts "\n\n"


