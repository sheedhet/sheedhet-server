require 'spec_helper'
require_relative '../../app/services/card_dealer.rb'

RSpec.describe CardDealer do
  let(:game) do
    OpenStruct.new(draw_pile: draw_pile, hand_size: size_size, player: players)
  end
  let(:hand) { double('Hand', CONTAINER_NAMES: [:one, :two, :three]) }

  describe '#deal_new_game' do
    subject { CardDealer.new(game) }
    before do
      # allow cards to receive shuffle! - should this be a pile method?
      # allow cards to receive pop
      # allow players to receive add_to
    end
  end
end
