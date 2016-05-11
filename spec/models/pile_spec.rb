require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/pile.rb'

RSpec.describe Pile do
  let(:content) { double(Card) }
  describe '.from_json' do
    let(:card1_face) { 'a' }
    let(:card1_suit) { 's' }
    let(:card2_face) { '9' }
    let(:card2_suit) { 'd' }
    let(:card1_json) { "#{card1_face}#{card1_suit}" }
    let(:card2_json) { "#{card2_face}#{card2_suit}" }
    let(:content) { double(Card) }
    subject { Pile.from_json("[#{card1_json}, #{card2_json}]", content) }

    # !!!!!!!!!!!!!!!!!!!!
    # learn some more about mocking classes in tests!!!
    # !!!!!!!!!!!!!!!!!!!!

    it do
      is_expected.to contain_exactly(
        Card.new(suit: card1_suit, face: card1_face),
        Card.new(suit: card2_suit, face: card2_face)
      )
    end
  end

  describe '#add' do
    let(:empty_pile) { [] }
    let(:card) { double('Card') }
    let(:pile_with_card) { empty_pile.push(card) }
    subject(:pile) { Pile.new(existing, card.class) }
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
