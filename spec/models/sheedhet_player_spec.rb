require 'rails_helper'

RSpec.describe SheedhetPlayer, type: :model do
  let(:hand_size) { 4 }

  let(:cards) do
    SheedhetPlayer::PILES.inject({}) do |cards, target|
      cards[target] = Array.new(hand_size).map{ Card.random_card }
      cards
    end
  end

  subject(:player) { SheedhetPlayer.new(cards: cards) }

  describe '#remove_from' do
    context 'card exists in target' do
      it 'removes the card' do
        target = SheedhetPlayer::PILES.sample
        card = player.cards[target].sample
        result = player.remove_from(card: card, target: target)
        expect(result).to eq(card)
        expect(player.cards[target]).not_to include(card)
      end
    end

    context 'card does not exist in target' do
      it 'should raise an error' do
        target = SheedhetPlayer::PILES.sample
        begin
          card = Card.random_card
        end while player.cards[target].include? card
        expect do
          player.remove_from(card: card, target: targets.last)
        end.to raise_error
      end
    end
  end

  describe '#add_to' do
    it 'adds the card' do
      target = SheedhetPlayer::PILES.sample
      begin
        card = Card.random_card
      end while player.cards[target].include? card
      result = player.add_to(card: card, target: target)
      expect(player.cards[target]).to include card
    end
  end
end
