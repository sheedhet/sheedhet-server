require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/models/player.rb'

RSpec.describe Player do
  let(:hand) { double(Hand) }

  let(:params) { { operator: :>=, value: 6 } }
  let(:player) { Player.new(cards: hand) }

  describe '#get_playable' do
    it 'sends #get_playable to cards' do
      expect(hand).to receive(:get_playable).with(params)
      player.get_playable(params)
    end
  end

  describe 'lowest_card' do
    it 'sends #min to cards' do
      expect(hand).to receive(:lowest_card)
      player.lowest_card
    end
  end
end
