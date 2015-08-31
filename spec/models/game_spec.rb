require 'rails_helper'

RSpec.describe Game do
  let(:lay) { LayCards::ACTION }
  let(:swap) { SwapCards::ACTION }
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.first }
  let(:turn) do
    Turn.build action: action, position: player.position, game: game
  end

  describe '#started?' do
    subject { game.started? }
    context 'history is greater than max possible' do
      let(:action) { SwapCards::ACTION }
      before { game.players.size.next.times { game.history << turn } }
      it { is_expected.to eq true }
    end

    context 'does not contain any LayCard Turns' do
      it { is_expected.to eq false }
    end

    context 'contains a LayCard Turn' do
      let(:action) { lay }
      before { game.history << turn }
      it { is_expected.to eq true }
    end
  end

  describe '#player_has_played?' do
    subject { game.player_has_played? player }
    context 'has played' do
      let(:action) { lay }
      before { game.history << turn }
      it { is_expected.to eq true }
    end

    context 'has not played' do
      it { is_expected.to eq false }
    end
  end
end
