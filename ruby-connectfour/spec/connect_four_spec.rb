# frozen_string_literal: true

require './lib/connect_four'
describe ConnectFour do
  describe '#create_array' do
    context 'creates a 2d array of 7 x 6 - stubbed, doubled' do
      let(:connect_four_arrays) { double('making_arrays') }
      before do
        set_array = Array.new(7) { Array.new(6, '[ ]') }
        allow(connect_four_arrays).to receive(:create_array).and_return(set_array)
      end

      it 'creates an array which contains 7 nested arrays' do
        expect(connect_four_arrays.create_array).to eq(Array.new(7) { Array.new(6, '[ ]') })
      end
    end

    context 'creates a 2d array of 7 x 6 - using method' do
      subject(:connect_four_board) { described_class.new }

      it 'main array has 7 elements' do
        main_array = connect_four_board.create_array
        expect(main_array.length).to eq(7)
      end

      it 'each subarray has 6 elements' do
        first_subarray = connect_four_board.create_array[0]
        expect(first_subarray.length).to eq(6)
      end

      it 'all elements in subarray are [ ]' do
        first_subarray = connect_four_board.create_array[0]
        expect(first_subarray).to be_all { |space| space.match('[ ]') }
      end
    end
  end

  describe '#drop_piece' do
    context 'player chooses column 1' do
      subject(:connect_four_drop) { described_class.new }

      it 'array gets unshifted and popped' do
        expected_result = ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]']
        affected_column = connect_four_drop.instance_variable_get(:@board)[0]
        connect_four_drop.drop_piece(1, 1)

        expect(affected_column).to eq(expected_result)
      end

      it 'array maintains size of six' do
        affected_column = connect_four_drop.instance_variable_get(:@board)[0]

        expect { connect_four_drop.drop_piece(1, 1) }
          .not_to change { affected_column.length }
      end
    end

    context 'player chooses column 0' do
      subject(:connect_four_drop) { described_class.new }
      setup_array = ['[ ]', '[ ]', '[ ]', '[1]', '[1]', '[1]']
      before do
        connect_four_drop.instance_variable_set(:@board, [setup_array])
      end

      it 'there are three pieces already' do
        expected_result = ['[ ]', '[ ]', '[1]', '[1]', '[1]', '[1]']

        expect { connect_four_drop.drop_piece(1, 1) }
          .to change { connect_four_drop.instance_variable_get(:@board)[0] }.to(expected_result)
      end
    end

    context 'player chooses a full column' do
      subject(:connect_four_drop) { described_class.new }
      let(:player) { 1 }
      setup_array =  ['[1]', '[1]', '[1]', '[1]', '[1]', '[1]']
      before do
        connect_four_drop.instance_variable_set(:@board, [setup_array])
        allow(connect_four_drop).to receive(:puts).with('column full')
      end

      it 'player_turn is called' do
        expect(connect_four_drop).to receive(:player_turn).with(player)
        connect_four_drop.drop_piece(1, 1)
      end
    end
  end

  describe '#player_input' do
    matcher :be_between_one_and_seven do
      match { |value| value.between?(1, 7) }
    end

    context 'input is between one and seven' do
      subject(:connect_four_input) { described_class.new }
      before do
        allow(connect_four_input).to receive(:print)
      end

      it 'player inputs 1' do
        allow(connect_four_input).to receive(:gets).and_return('1')
        expect(connect_four_input.player_input(1)).to be_between_one_and_seven
      end

      it 'player inputs 3' do
        allow(connect_four_input).to receive(:gets).and_return('3')
        expect(connect_four_input.player_input(1)).to be_between_one_and_seven
      end

      it 'player inputs 7' do
        allow(connect_four_input).to receive(:gets).and_return('7')
        expect(connect_four_input.player_input(1)).to be_between_one_and_seven
      end
    end

    context 'input is not between one and seven' do
      subject(:connect_four_input) { described_class.new }
      error = 'Invalid input, choose between 1-7'

      before do
        allow(connect_four_input).to receive(:print)
      end

      it 'player inputs invalid and then valid' do
        allow(connect_four_input).to receive(:gets).and_return('10', '4')
        expect(connect_four_input).to receive(:puts).with(error).once
        connect_four_input.player_input(1)
      end

      it 'player inputs 2 invalid inputs and then valid' do
        allow(connect_four_input).to receive(:gets).and_return('a', '32', '4')
        expect(connect_four_input).to receive(:puts).with(error).twice
        connect_four_input.player_input(1)
      end

      it 'player inputs a letter and then inputs valid' do
        allow(connect_four_input).to receive(:gets).and_return('a', '7')
        expect(connect_four_input).to receive(:puts).with(error).once
        connect_four_input.player_input(1)
      end
    end
  end

  describe '#winner?' do
    subject(:connect_four_winner) { described_class.new }

    context 'winner has been decided' do
      it 'returns true' do
        connect_four_winner.instance_variable_set(:@winner, 1)
        expect(connect_four_winner.winner?).to be true
      end
    end

    context 'winner has not been decided' do
      it 'returns false' do
        expect(connect_four_winner.winner?).to be false
      end
    end
  end

  describe '#update_winner' do
    subject(:connect_four_winner) { described_class.new }

    context 'fresh game, winner has not been determined' do
      it 'winner is nil' do
        winner = connect_four_winner.instance_variable_get(:@winner)
        expect(winner).to be_nil
      end
    end

    context 'sets winner' do
      it 'sets player one as winner' do
        expect { connect_four_winner.update_winner(1) }
          .to change { connect_four_winner.instance_variable_get(:@winner) }.to(1)
      end

      it 'sets player two as winner' do
        expect { connect_four_winner.update_winner(2) }
          .to change { connect_four_winner.instance_variable_get(:@winner) }.to(2)
      end
    end
  end

  describe '#arrange_board' do
    describe 'converts arrays (columns) into rows' do
      context 'each row contains an element from each column' do
        subject(:connect_four_arrange) { described_class.new }

        it 'takes an element from each column' do
          test_board = [[1, 2, 3], [4, 5, 6]]
          expected = [[1, 4], [2, 5], [3, 6]]
          result = connect_four_arrange.arrange_board(test_board)
          expect(result).to eq(expected)
        end

        it 'takes an string element from each column' do
          test_board = [['[1]', '[2]', '[3]'], ['[4]', '[5]', '[6]']]
          expected = [['[1]', '[4]'], ['[2]', '[5]'], ['[3]', '[6]']]

          result = connect_four_arrange.arrange_board(test_board)
          expect(result).to eq(expected)
        end
      end
    end
  end

  describe '#consecutive_four?' do

    # configured_board = [
    #   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
    #   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
    #   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
    #   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
    #   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
    #   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
    #   ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
    # ]

    describe 'checks each @board arrays if any array contains four consecutive elements' do
      subject(:consec_four) { described_class.new }

      context 'returns true if there are four consecutive elements in the array' do
        it 'there are four consecutive elements in @board[1]' do
          configured_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[1]', '[1]', '[1]', '[1]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]

          consec_four.instance_variable_set(:@board, configured_board)
          expect(consec_four.consecutive_four?(configured_board)).to be true
        end

        it 'board is filled, only consecutive four is in @board[4]' do
          configured_board = [
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[2]', '[1]', '[1]', '[1]', '[1]', '[2]'], # <-- win @board[4]
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]']
          ]

          consec_four.instance_variable_set(:@board, configured_board)
          expect(consec_four.consecutive_four?(configured_board)).to be true
        end
      end

      context 'returns false if there are not four consecutive elements' do
        it 'there are no consecutives in any columns' do
          configured_board = [
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[2]', '[1]', '[2]', '[1]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]']
          ]

          consec_four.instance_variable_set(:@board, configured_board)
          expect(consec_four.consecutive_four?(configured_board)).to be false
        end
      end
    end
  end

  describe '#det_winner_horizontal' do
    describe 'checks each @board array for four consecutive horizontal in same index' do
      subject(:det_horizontal) { described_class.new }

      context 'returns true if @board[x][space] has 4 consecutives' do
        it 'four consecutives on bottom row' do
          configured_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]

          det_horizontal.instance_variable_set(:@board, configured_board)
          expect(det_horizontal.det_winner_horizontal?).to be true
        end

        it 'four consecutives surrounded by nonconsecutive tokens, third row wins' do
          configured_board = [
            ['[1]', '[2]', '[1]', '[1]', '[2]', '[1]'],
            ['[2]', '[1]', '[2]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[2]', '[1]', '[2]', '[1]'],
            ['[2]', '[1]', '[2]', '[2]', '[1]', '[2]'],
            ['[2]', '[1]', '[2]', '[1]', '[2]', '[1]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[1]', '[2]', '[1]']
          ]

          det_horizontal.instance_variable_set(:@board, configured_board)
          expect(det_horizontal.det_winner_horizontal?).to be true
        end
      end

      context 'returns false if there are no 4 consecutives in a row' do
        it 'whole board is nonconsecutive row-wise' do
          configured_board = [
            ['[1]', '[2]', '[1]', '[1]', '[2]', '[1]'],
            ['[2]', '[1]', '[2]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[2]', '[1]', '[2]', '[1]'],
            ['[2]', '[1]', '[1]', '[2]', '[1]', '[2]'],
            ['[2]', '[1]', '[2]', '[1]', '[2]', '[1]'],
            ['[1]', '[2]', '[1]', '[2]', '[1]', '[2]'],
            ['[1]', '[2]', '[1]', '[1]', '[2]', '[1]']
          ]

          det_horizontal.instance_variable_set(:@board, configured_board)
          expect(det_horizontal.det_winner_horizontal?).to be false
        end
      end
    end
  end

  describe '#diagonal_helper?' do
    describe 'checks for consecutive tokens within three diagonal spaces from given index' do
      subject(:diagonal_helper) { described_class.new }
      context 'diagonal_helper_top_left?, key is [-1, -1]' do
        key = [-1, -1]

        it 'returns false when first top left space is empty' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([2, 3], board, key)).to be false
        end

        it 'returns false when there are two consecutives, not four' do
          configured_transposed_board = [
            ['[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([2, 3], board, key)).to be false
        end

        it 'returns false when there are four consecutives starting from [3, 4]' do
          configured_transposed_board = [
            ['[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([3, 4], board, key)).to be true
        end

        it 'returns false when invalid top left space' do
          configured_transposed_board = [
            ['[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([0, 0], board, key)).to be false
        end

        it 'returns false when there is different token' do
          configured_transposed_board = [
            ['[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[2]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([5, 5], board, key)).to be false
        end
      end

      context 'diagonal_helper_top_right?, key is [-1, 1]' do
        key = [-1, 1]

        it 'returns false when first top right space is empty' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([2, 3], board, key)).to be false
        end

        it 'returns false when first top right space is a different token' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[2]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([3, 5], board, key)).to be false
        end

        it 'returns false when first top right space is invalid' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([0, 5], board, key)).to be false
        end

        it 'returns true when first top right space is empty' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[2]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[2]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([4, 2], board, key)).to be true
        end

        it 'returns false when there is different token at second immediate space' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[2]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[2]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[2]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([4, 2], board, key)).to be false
        end
      end

      context 'diagonal_helper_bot_left?, key is [1, -1]' do
        key = [1, -1]

        it 'returns false when first bot left space is empty' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([3, 1], board, key)).to be false
        end

        it 'returns false when first bot left space is invalid' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([5, 4], board, key)).to be false
        end

        it 'returns true when there is consecutive diagonal from [2, 6]' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([2, 6], board, key)).to be true
        end
      end

      context 'diagonal_helper_bot_right?, key is [1, 1]' do
        key = [1, 1]

        it 'returns false when first bot right space is empty' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([3, 1], board, key)).to be false
        end

        it 'returns false when first bot right space is invalid' do
          configured_transposed_board = [
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([5, 1], board, key)).to be false
        end

        it 'returns true when there is consecutive diagonal from [0, 1]' do
          configured_transposed_board = [
            ['[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[1]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]'],
            ['[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]', '[ ]']
          ]
          diagonal_helper.instance_variable_set(:@board, configured_transposed_board)
          board = diagonal_helper.instance_variable_get(:@board)

          expect(diagonal_helper.diagonal_helper?([0, 1], board, key)).to be true
        end
      end
    end
  end
end
