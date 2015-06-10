require 'rails_helper'

RSpec.describe Player do
  let(:simple_hand) do
    Player.new_hand({ in_hand: Pile.from_json(['4h', '5h', '6h', '7h', '8h']) })
  end
  let(:player) { Player.new }


  describe '#get_playable_from' do
    context 'getting values greater than/equal to' do
      before do
        player.cards = simple_hand
      end

      subject { player.get_playable_from(operator: :>=, value: 6) }

      it "returns only cards with values greater than or equal to" do
        expect(subject[:in_hand].count{ |card| card.value < 6 }).to eq(0)
      end
    end
  end
end
