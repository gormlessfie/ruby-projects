# frozen_string_literal: true

require 'pry-byebug'
# ConnectFour creates a board and manipulates it.
class ConnectFour
  def initialize
    @board = create_array
    @winner = nil
  end

  def create_array
    Array.new(7) { Array.new(6, '[ ]') }
  end

  def game_loop
    player_turn(1)
    return game_over if winner?

    player_turn(2)
    return game_over if winner?

    game_loop
  end

  def drop_piece(column, player)
    if @board[column - 1].first.match('[ ]')
      next_last_pos = @board[column - 1].rindex { |value| value.match('[ ]') }
      @board[column - 1][next_last_pos] = "[#{player}]"
    else
      puts 'column full'
      player_turn(player)
    end
  end

  def player_turn(player)
    display_board
    drop_piece(player_input(player), player)
    det_winner(player)
  end

  def player_input(player)
    loop do
      print "#{player}'s turn. Choose a column between 1-7 to place your token: "
      input = gets.chomp.to_i
      return input if input.between?(1, 7)

      puts 'Invalid input, choose between 1-7'
    end
  end

  def update_winner(player)
    @winner = player
  end

  def winner?
    @winner.nil? ? false : true
  end

  def game_over
    puts "\n"
    puts "\n"
    display_board
    puts "Game over. #{@winner} wins!"
  end

  def det_winner_vertical?(board = @board)
    consecutive_four?(board)
  end

  def det_winner_horizontal?(board = @board)
    converted_board = board.transpose
    consecutive_four?(converted_board)
  end

  def det_winner_diagonal?(board = @board.transpose)
    @board.each_with_index do |_row, ridx|
      column.each_with_index do |column, cidx|
        next if column == '[ ]'

        return true if diagonal_helper_top_left?([ridx, cidx], board)
      end
    end
    false
  end

  def diagonal_helper_top_left?(index, board)
    key = [-1, -1]
    count = 0
    current_space = board[index[0]][index[1]]

    3.times do
      index[0] += key[0]
      index[1] += key[1]
      return false if index[0].negative? || index[1].negative? ||
                      index[0] > 5 || index[1] > 6

      diagonal_space = board[index[0]][index[1]]
      return false if diagonal_space == '[ ]' || diagonal_space != current_space

      count += 1
    end

    return true if count == 3
  end

  def diagonal_helper_top_right?(space)
    key = [1, -1]

  end

  def diagonal_helper_bot_left?(space)
    key = [-1, 1]

  end

  def diagonal_helper_bot_right?(space)
    key = [1, 1]
    
  end

  def det_winner(player)
    update_winner(player) if det_winner_vertical? || det_winner_horizontal? || det_winner_diagonal?
  end

  def consecutive_four?(board)
    board.each do |column|
      next if column.all?('[ ]')

      count = 0
      previous = nil

      column.each do |space|
        if space == '[ ]'
          count = 0
          next
        end
        space == previous ? count += 1 : count = 0
        previous = space
        return true if count == 3
      end
    end
    false
  end

  def arrange_board(board)
    arranged_board = Array.new(board[0].length) { Array.new(board.length) }

    board[0].length.times do |i|
      board.each_with_index do |_column, cidx|
        arranged_board[i][cidx] = board[cidx][i]
      end
    end
    arranged_board
  end

  def display_board(board = arrange_board(@board))
    board.each do |row|
      p row
    end
  end

  def compare_board
    puts 'raw board: '
    display_board(@board)
    puts "\n"
    puts 'arranged board'
    display_board
  end
end

def fill_board
  c = ConnectFour.new
  c.drop_piece(1, 1)
  c.drop_piece(1, 1)
  c.drop_piece(1, 1)
  c.drop_piece(1, 1)
  c.drop_piece(1, 1)

  c.drop_piece(2, 2)
  c.drop_piece(2, 2)
  c.drop_piece(2, 2)
  c.drop_piece(2, 2)
  c.drop_piece(2, 2)

  c.drop_piece(3, 3)
  c.drop_piece(3, 3)
  c.drop_piece(3, 3)
  c.drop_piece(3, 3)
  c.drop_piece(3, 3)

  c.drop_piece(4, 4)
  c.drop_piece(4, 4)
  c.drop_piece(4, 4)
  c.drop_piece(4, 4)
  c.drop_piece(4, 4)

  c.drop_piece(5, 5)
  c.drop_piece(5, 5)
  c.drop_piece(5, 5)
  c.drop_piece(5, 5)
  c.drop_piece(5, 5)

  c.drop_piece(6, 6)
  c.drop_piece(6, 6)
  c.drop_piece(6, 6)
  c.drop_piece(6, 6)
  c.drop_piece(6, 6)

  c.drop_piece(7, 7)
  c.drop_piece(7, 7)
  c.drop_piece(7, 7)
  c.drop_piece(7, 7)
  c.drop_piece(7, 7)

  c.instance_variable_set(:@board, c.instance_variable_get(:@board).transpose)
  c.display_board(c.instance_variable_get(:@board))
end

# c = ConnectFour.new

# configured_transposed_board = [
#   ['[ ]', '[]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
#   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
#   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
#   ['[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
#   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
#   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
#   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
# ]
# c.instance_variable_set(:@board, configured_transposed_board)

# p c.diagonal_helper_top_left?([3, 0], c.instance_variable_get(:@board))
