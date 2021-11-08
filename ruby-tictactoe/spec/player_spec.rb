# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  describe '#verify_input' do
    subject(:player_billy) { described_class.new('billy') }

    context 'Input is valid and array returned is correct' do
      before do
        allow(player_billy).to receive(:gets).and_return('5')
      end

      it 'Input is 5' do
        expect(player_billy.verify_input).to eq([5, 'billy'])
      end
    end

    context 'Input is invalid twice and then valid' do
      before do
        allow(player_billy).to receive(:puts).twice
        allow(player_billy).to receive(:gets).and_return('a', 'b', '5')
      end

      it 'Two invalid message and then valid' do
        expect(player_billy.verify_input).to eq([5, 'billy'])
      end
    end
    context 'Invalid input and then valid' do
      before do
        allow(player_billy).to receive(:puts).once
        allow(player_billy).to receive(:gets).and_return('a', '4')
      end

      it 'Invalid input and then valid' do
        expect(player_billy.verify_input).to eq([4, 'billy'])
      end
    end
  end
end
