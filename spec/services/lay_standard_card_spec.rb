require 'rails_helper'

RSpec.describe LayStandardCard do
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.sample }
  let(:action) { LayStandardCard::ACTION }
  let(:position) { player.position }
  let(:from_in_hand) { player.cards[:in_hand].sample(2) }

  let(:regular) do
    Turn.build(
      action: action,
      from_in_hand: from_in_hand,
      game: game,
      position: position
    )
  end

  describe '#valid?' do
    subject { regular.valid? }

    context 'play is in valid_plays' do
      before { game.valid_plays << regular }
      it { is_expected.to be true }
    end

    context 'play is not in valid_plays' do
      it { is_expected.to be false }
    end
  end

  describe '#execute' do
    # to do
  end
end
