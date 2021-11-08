# frozen_string_literal: true

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
    return if winner?

    player_turn(1)
    player_turn(2)
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
    drop_piece(player_input, player)
  end

  def player_input
    loop do
      print 'Choose a column between 1-7 to place your token: '
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

  def display_board
    formatted_board = arrange_board(@board)
    formatted_board.each_with_index do |row, ridx|
      p row
    end
  end

  def det_winner_vertical
    # check for any four consecutive values in single @board array
    # ie. @board[0][0] = 1, @board[0][1] = 1, @board[0][2] = 1, @board[0][3] = 1
  end

  def det_winner_horizontal
    # check for any four consecutive values from each @board array space
    # ie. @board[0][0] = 1, @board[1][0] = 1, @board[2][0] = 1, @board[3][0] = 1
  end

  def det_winner_diagonal
  end

  def det_winner
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

  def display_raw_board
    @board.each do |row|
      p row
    end
  end

  def compare_board
    puts 'raw board: '
    display_raw_board
    puts "\n"
    puts 'arranged board'
    display_board
  end
end

c = ConnectFour.new

c.drop_piece(1, 1)
c.drop_piece(1, 1)
c.drop_piece(1, 1)
c.drop_piece(1, 1)

c.drop_piece(2, 2)
c.drop_piece(2, 2)
c.drop_piece(2, 2)
c.drop_piece(2, 2)

c.drop_piece(3, 3)
c.drop_piece(3, 3)
c.drop_piece(3, 3)
c.drop_piece(3, 3)

c.drop_piece(4, 4)
c.drop_piece(4, 4)
c.drop_piece(4, 4)
c.drop_piece(4, 4)

c.drop_piece(5, 5)
c.drop_piece(5, 5)
c.drop_piece(5, 5)
c.drop_piece(5, 5)

c.drop_piece(6, 6)
c.drop_piece(6, 6)
c.drop_piece(6, 6)
c.drop_piece(6, 6)

c.drop_piece(7, 7)
c.drop_piece(7, 7)
c.drop_piece(7, 7)
c.drop_piece(7, 7)

c.compare_board
