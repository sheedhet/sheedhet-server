require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/pile.rb'

RSpec.describe Pile do
  let(:empty_pile) { [] }
  let(:card) { double('Card') }
  let(:pile_with_card) { empty_pile.push(card) }
  subject(:pile) { Pile.new(existing, card.class) }

  describe '#add' do
    context 'adding a card' do
      let(:existing) { empty_pile }
      before { pile.add card }
      it { is_expected.to include card }
      it { expect(pile.size).to eq 1 }
    end
  end

  describe '#remove' do
    context 'card is in pile' do
      let(:existing) { pile_with_card }
      before { pile.remove card }
      it { is_expected.not_to include card }
      it { expect(pile.size).to eq 0 }
    end

    context 'card not in pile' do
      let(:existing) { empty_pile }
      it { expect { pile.remove card }.to raise_error(ArgumentError) }
    end
  end
end
