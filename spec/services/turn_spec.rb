require 'spec_helper'
require_relative '../../app/services/game_factory.rb'

RSpec.describe Turn do
  let(:game) { GameFactory.new.build }
  let(:turn) { Turn.build action: 'lay_cards', position: 0, game: game }

  describe '#valid?' do
    subject { turn.valid? }
    context 'is in @valid_turns' do
      before { game.valid_turns << turn }
      it { is_expected.to eq true }
    end

    context 'is not in @valid_turns' do
      it { is_expected.to eq false }
    end
  end
end
