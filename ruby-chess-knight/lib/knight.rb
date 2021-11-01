# frozen_string_literal: true

require 'pry-byebug'
# This defines where a knight chess piece can move
class Knight
  attr_accessor :chess_board, :legal_moves
  def initialize
    # board has a layout as such: An array of 8 arrays which hold 8 arrays each
    # [
    #  [ [[possible moves from [0,0]], [], [], [], [], [], [], [] ]
    #  [ [], [], [], [], [], [], [], [] ]
    #  [ [], [], [], [], [], [], [], [] ]
    #  [ [], [], [], [], [], [], [], [] ]
    #  [ [], [], [], [], [], [], [], [] ]
    #  [ [], [], [], [], [], [], [], [] ]
    #  [ [], [], [], [], [], [], [], [] ]
    #  [ [], [], [], [], [], [], [], [] ]
    # ]
    @chess_board = build_board
    @legal_moves = build_graph
  end
  # Takes an array with a starting coordinate [x, y] and finds the shortest path
  # to finish [x, y] by only using possible moves below

  # [-2,-1], [-2, 1], 2 Left
  # [-1, -2], [-1, 2], 1 Left
  # [1, -2], [1, 2], 1 Right
  # [2, -1], [2, 1], 2 Right

  def knight_moves(start, finish)
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
end
