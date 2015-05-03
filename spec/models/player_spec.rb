require 'rails_helper'

RSpec.describe Player do
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.sample }
  let(:target) { Player::PILES.sample }
  let(:card) { player.cards[target].sample }
  subject(:cards) { player.cards[target] }

  # describe '#remove_from' do
  #   context 'card exists in target' do
  #     let!(:removed) { player.remove_from(card: card, target: target) }
  #     it { expect(removed).to be card }
  #     it { is_expected.not_to include(card) }
  #   end

  #   context 'card does not exist in target' do
  #     let(:card) { Card.new(suit: 's', face: '0') }
  #     it 'should raise error' do
  #       expect do
  #         player.remove_from(card: card, target: target)
  #       end.to raise_error
  #     end
  #   end
  # end

  # describe '#add_to' do
  #   let(:card) { Card.new(suit: 's', face: '0') }
  #   before { player.add_to(card: card, target: target) }
  #   it {is_expected.to include card }
  # end
end
