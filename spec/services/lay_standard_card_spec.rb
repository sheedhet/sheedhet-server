require 'rails_helper'

RSpec.describe LayStandardCard do
  let!(:game) { GameFactory.new.build }
  let!(:player) { game.players.sample }
  let!(:action) { 'regular' }
  let!(:position) { player.position }
  let!(:source) { Player::PILES.sample }
  let!(:card) { player.cards[source].sample }
  let!(:regular) do
    LayStandardCard.new(
      action: action,
      game: game,
      position: position,
      card: card,
      source: source
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
