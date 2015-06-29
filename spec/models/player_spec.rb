require 'rails_helper'

RSpec.describe Player do
  let(:simple_hand) do
    Hand.new({ in_hand: Pile.from_json(['4h', '5h', '6h', '7h', '8h']) })
  end
  let(:player) { Player.new(cards: simple_hand) }

  # before { require 'pry'; binding.pry }
  describe '#get_playable' do
    context 'getting values greater than/equal to' do
      subject { player.get_playable(operator: :>=, value: 6) }

      it "returns only cards with values greater than or equal to" do
        expect(subject[:in_hand].count{ |card| card.value < 6 }).to eq(0)
      end
    end
  end
end
