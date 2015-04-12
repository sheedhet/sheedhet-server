require 'rails_helper'

RSpec.describe SheedhetPlayer, type: :model do
  let(:hand_size) { 4 }
  let(:cards) do
    SheedhetPlayer::PILES.inject({}) do |cards, target|
      cards[target] = Array.new(hand_size).map{ Card.random_card }
      cards
    end
  end
  subject(:player) { SheedhetPlayer.new(cards: cards, position: 0) }

  describe '#remove_from' do
    context 'with valid input' do
      it 'removes the card' do
        target = SheedhetPlayer::PILES.sample
        card = player.cards[target].sample
        result = player.remove_from(card: card, target: target)
        expect(result).to eq(card)
        expect(player.cards[target]).not_to include(card)
      end

    end
    context 'when invalid input' do
      it 'should raise an error' do
        targets = SheedhetPlayer::PILES.sample(2)
        card = player.cards[targets.first].sample
        expect do
          player.remove_from(card: card, target: targets.last)
        end.to raise_error
      end
    end
  end

  describe '#add_to' do
    context 'with valid input' do
      it 'adds the card' do
        target = SheedhetPlayer::PILES.sample
        card = player.cards[target].sample
        result = player.add_to(card: card, target: target)
        expect(player.cards[target]).to include card
      end
    end
  end
end
