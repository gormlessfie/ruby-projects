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
    formatted_board.each_with_index do |row, idx|
      p formatted_board[idx]
    end
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
end

c = ConnectFour.new
c.game_loop
