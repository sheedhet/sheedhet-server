require 'rails_helper'

RSpec.describe LayCards do
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.sample }
  let(:action) { LayCards::ACTION }
  let(:position) { player.position }
  let(:target) { Player::PILES.sample }
  let(:pile) { "from_#{target}".to_sym }
  let(:played_cards) { Hash.new([]) }
  let(:random_card) { player.cards[target].sample }
  before { played_cards[target] = [random_card] }

  let(:lay_card) do
    Turn.build(
      action: action,
      game: game,
      play_cards: played_cards,
      position: position
    )
  end

  describe '#valid?' do
    subject { lay_card.valid? }

    context 'play is in valid_plays' do
      before { game.valid_plays << lay_card.dup }
      it { is_expected.to be true }
    end

    context 'play is not in valid_plays' do
      it { is_expected.to be false }
    end
  end

  describe '#execute' do
    before { lay_card.execute }
    it { expect(player.cards[target]).to include random_card }
    it { expect(game.play_pile).not_to include random_card }
  end
end
