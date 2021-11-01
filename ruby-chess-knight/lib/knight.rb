# frozen_string_literal: true

# This defines where a knight chess piece can move
class Knight
  attr_accessor :chess_board, :legal_moves, :chess_board_info

  def initialize
    @legal_moves = build_graph
    @chess_board_info = build_info
  end

  def knight_moves(start, finish)
    p "Selected: #{start} , #{finish}"
    bfs_start_end(start, finish)

    print_summary(start, finish)
  end

  private

  def bfs_start_end(start, finish)
    queue = []
    current = nil

    queue.push(start)
    lookup_square_info(start)[:distance] = 0

    until queue.empty?
      current = queue.shift
      neighbor = @legal_moves[current[0]][current[1]]

      neighbor.each do |node|
        next unless lookup_square_info(node)[:distance].nil?

        lookup_square_info(node)[:distance] = lookup_square_info(current)[:distance] + 1
        lookup_square_info(node)[:predecessor] = current
        queue.push(node)
      end
    end
  end

  def build_board
    board = Array.new(8) { Array.new(8) }
    board.each_with_index do |row, ridx|
      row.each_with_index do |_square, cidx|
        board[ridx][cidx] = [ridx, cidx]
      end
    end
  end

  def build_graph
    temp_board = build_board
    assign_moves(temp_board)
  end

  def build_info
    temp_board = build_board

    temp_board.each_with_index do |row, ridx|
      row.each_with_index do |_square, sidx|
        temp_board[ridx][sidx] = {
          distance: nil,
          predecessor: nil
        }
      end
    end
    temp_board
  end

  def lookup_square_info(square)
    @chess_board_info[square[0]][square[1]]
  end

  def lookup_legal_moves(array)
    @legal_moves[array[0]][array[1]]
  end

  def assign_moves(array)
    array.each_with_index do |row, ridx|
      row.each_with_index do |_square, sidx|
        array[ridx][sidx] = Array.new(8) { [ridx, sidx] }
      end
    end

    array.each_with_index do |row, ridx|
      row.each_with_index do |square, sidx|
        square.each_with_index do |possible, pidx|
          array[ridx][sidx][pidx] = calc_legal_moves(possible, pidx)
        end
        array[ridx][sidx] = array[ridx][sidx].compact
      end
    end
    array
  end

  def calc_legal_moves(possibility, index)
    case index
    when 0
      possibility[0] += -2
      possibility[1] += -1
    when 1
      possibility[0] += -2
      possibility[1] += 1
    when 2
      possibility[0] += -1
      possibility[1] += -2
    when 3
      possibility[0] += -1
      possibility[1] += 2
    when 4
      possibility[0] += 1
      possibility[1] += -2
    when 5
      possibility[0] += 1
      possibility[1] += 2
    when 6
      possibility[0] += 2
      possibility[1] += -1
    when 7
      possibility[0] += 2
      possibility[1] += 1
    end
    possibility if possibility[0].between?(0, 7) && possibility[1].between?(0, 7)
  end

  def print_summary(start, finish)
    history_of_moves = []

    history_of_moves.unshift(finish)
    history_of_moves.unshift(lookup_square_info(finish)[:predecessor])

    puts "You made it in #{lookup_square_info(finish)[:distance]} moves! The path was: "

    history_of_moves.unshift(lookup_square_info(history_of_moves[0])[:predecessor]) until
    history_of_moves[0] == start

    p history_of_moves
  end

  public

  def print_legal_moves
    @legal_moves.each_with_index do |row, ridx|
      row.each_with_index do |square, sidx|
        puts "Square [#{ridx}, #{sidx}]: #{square} "
      end
    end
  end

  def print_chess_board
    @chess_board.each do |row|
      p row
    end
  end

  def print_chess_board_info
    @chess_board_info.each_with_index do |row, ridx|
      row.each_with_index do |square, sidx|
        p "[#{ridx}, #{sidx}]: #{square}"
      end
    end
  end
end
