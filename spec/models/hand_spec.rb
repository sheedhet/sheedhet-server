require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/card.rb'
require_relative '../../app/models/pile.rb'
require_relative '../../app/models/hand.rb'

RSpec.describe Hand do
  let(:hand) { Hand.new(in_hand: pile) }
  let(:pile) { double(Pile, get: double('pile', all_same?: true)) }
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

  describe 'lowest_card' do
    it 'sends #min to :in_hand Pile' do
      expect(hand[:in_hand]).to receive(:min)
      hand.lowest_card
    end
  end

  describe '#trim_unplayable' do
  end

  describe '#lowest_card' do
  end
end
