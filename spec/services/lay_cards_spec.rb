require 'rails_helper'

RSpec.describe LayCards do
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.sample }
  let(:action) { LayCards::ACTION }
  let(:position) { player.position }
  let(:target) { player.cards.keys.sample }
  let(:played_cards) { Hand.new }
  let(:random_card) { player.cards[target].sample }
  before { played_cards[target] << random_card }

  let(:lay_card) do
    Turn.build(
      action: action,
      game: game,
      play_cards: played_cards,
      position: position
    )
  end

  describe '#execute' do
    before { lay_card.execute }
    it {
      require 'pry'
      binding.pry
      expect(player.cards[target]).not_to include random_card
    }
    it { expect(game.play_pile.pop).to eq random_card }
  end
end
