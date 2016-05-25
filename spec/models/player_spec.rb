require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/models/player.rb'

RSpec.describe Player do
  # let(:params) { { operator: :>=, value: 6 } }
  # let(:player) { Player.new }
  # let(:hand) { player.cards }
  #
  # describe '#get_playable' do
  #   it 'sends #get_playable to cards' do
  #     expect(hand).to receive(:get_playable).with(params)
  #     player.get_playable(params)
  #   end
  # end
  #
  # describe 'lowest_card' do
  #   it 'sends #min to cards' do
  #     expect(hand).to receive(:lowest_card)
  #     player.lowest_card
  #   end
  # end
  #
  # describe 'take_card' do
  #   it 'adds card to in_hand Pile' do
  #     expect(hand[:in_hand]).to receive(:add).with(taken_card)
  #     player.take_card(taken_card)
  #   end
  # end
end
