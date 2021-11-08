# frozen_string_literal: true

require './lib/game_board'
require './lib/player'

describe Board do
  describe '#det_winner' do
    subject(:board) { described_class.new }
    let(:player_one) { Player.new('billy') }

    context 'player_one wins, top row xs' do
      before do
        allow(player_one).to receive(:win_value).and_return([1, 2, 3])
      end

      it 'player one wins, 123' do
        expect { board.det_winner(player_one) }.to change { player_one.winner }
          .from(false).to(true)
      end
    end

    context 'player_one wins, diagonal left-to-right' do
      before do
        allow(player_one).to receive(:win_value).and_return([1, 5, 9])
      end

      it 'player_one wins, 159' do
        expect { board.det_winner(player_one) }.to change { player_one.winner }
          .from(false).to(true)
      end
    end

    context 'player_one does not have win condition' do
      before do
        allow(player_one).to receive(:win_value).and_return([1, 2, 4])
      end

      it 'player_one has not won, 124' do
        expect { board.det_winner(player_one) }.not_to change { player_one.winner }
      end
    end
  end
end
