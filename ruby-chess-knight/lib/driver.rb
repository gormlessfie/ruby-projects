# frozen_string_literal: true

require './lib/knight'

knight = Knight.new

# puts 'Chess board'
# knight.print_chess_board

# puts "\n\n"

# puts 'List of Possible moves per square'
# knight.print_legal_moves

# puts "\n\n"

# knight.bfs_start_end([0, 0], [4, 4])

knight.knight_moves([4, 7], [2, 0])
