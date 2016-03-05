require 'spec_helper'
require_relative '../../app/services/game_factory.rb'

RSpec.describe GameFactory do
  let(:params) { { operator: :>=, value: 6 } }
  let(:player) { Player.new }
  let(:hand) { player.cards }

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
