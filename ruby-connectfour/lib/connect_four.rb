# frozen_string_literal: true

# ConnectFour creates a board and manipulates it.
class ConnectFour
  def initialize
    @board = create_array
    @winner = nil
  end

  def create_array
    Array.new(7) { Array.new(6, nil) }
  end

  def game_loop
    return if winner?

    player_turn(1)
    player_turn(2)
    game_loop
  end

  def drop_piece(column, player)
    column -= 1
    if @board[column].last.nil?
      @board[column].unshift(player)
      @board[column].pop
    else
      puts 'column full'
      player_turn(player)
    end
  end

  def player_turn(player)
    drop_piece(player_input, player)
  end

  def player_input
    loop do
      print 'Choose a column between 0-6 to place your token: '
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
end
