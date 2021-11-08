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
        expect(connect_four_input.player_input).to be_between_one_and_seven
      end

      it 'player inputs 3' do
        allow(connect_four_input).to receive(:gets).and_return('3')
        expect(connect_four_input.player_input).to be_between_one_and_seven
      end

      it 'player inputs 7' do
        allow(connect_four_input).to receive(:gets).and_return('7')
        expect(connect_four_input.player_input).to be_between_one_and_seven
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
        connect_four_input.player_input
      end

      it 'player inputs 2 invalid inputs and then valid' do
        allow(connect_four_input).to receive(:gets).and_return('a', '32', '4')
        expect(connect_four_input).to receive(:puts).with(error).twice
        connect_four_input.player_input
      end

      it 'player inputs a letter and then inputs valid' do
        allow(connect_four_input).to receive(:gets).and_return('a', '7')
        expect(connect_four_input).to receive(:puts).with(error).once
        connect_four_input.player_input
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

  describe '#determine_winner' do
    describe 'checks the board' do
      
    end
  end
end
