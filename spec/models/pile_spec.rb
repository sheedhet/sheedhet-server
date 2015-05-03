require 'rails_helper'

RSpec.describe Pile do
  let(:pile_size) { 3 }
  let(:pile) { Pile.new Array.new(pile_size).map { Card.random_card } }
  let(:in_pile) { pile.sample }
  let(:not_in_pile) { Card.new(face: '0', suit: 'h') }
  subject { pile }

  describe '#add' do
    before { pile.add not_in_pile }
    it { is_expected.to include not_in_pile }
    it { expect(pile.size).to eq pile_size.next }
  end

  describe '#remove' do
    context 'card is in pile' do
      before { pile.remove in_pile }
      it { is_expected.not_to include in_pile }
      it { expect(pile.size).to eq pile_size.pred }
    end

    context 'card not in pile' do
      it { expect{ pile.remove not_in_pile }.to raise_error }
    end
  end
end
