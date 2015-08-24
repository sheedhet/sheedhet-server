require 'rails_helper'

RSpec.describe Hand do
  let(:hand) { Hand.new(in_hand: pile) }
  let(:pile) { double(Pile, get: double(Pile, all_same?: true)) }
  let(:operator) { :>= }
  let(:value) { 6 }
  let(:params) { { operator: operator, value: value } }

  describe '#get_playable' do
    context 'getting values greater than/equal to' do
      it 'sends #get to pile with params' do
        expect(pile).to receive(:get).with(operator, value)
        hand.get_playable(params)
      end
    end
  end

  # describe 'lowest_card' do
  #   it 'sends #min to cards' do
  #     expect(hand).to receive(:lowest_card)
  #     player.lowest_card
  #   end
  # end

  describe '#trim_unplayable' do
  end

  describe '#lowest_card' do
  end

  describe '#flatten' do
  end
end
