require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/pile.rb'

RSpec.describe Pile do
  let(:content) { double('Card') }

  describe '.from_json' do
    let(:card1_json) { 'as' }
    let(:card2_json) { '9d' }
    let(:pile_json) { "[\"#{card1_json}\", \"#{card2_json}\"]" }

    it 'passes on the .from_json to the collection contents' do
      expect(content).to receive(:from_json).with(card1_json)
      expect(content).to receive(:from_json).with(card2_json)
      expect(Pile.from_json(pile_json, content)).to be_a(Pile)
    end
  end

  describe '#add' do
    let(:empty_pile) { Pile.new }
    let(:card) { instance_double('Card') }
    let(:pile_with_card) { Pile.new([card]) }
    subject(:pile) { empty_pile.add(card) }
    it { is_expected.to include card }
    it { is_expected.not_to be_empty }
  end

  describe '#remove' do
    let(:card) { double('Card') }
    let(:pile_without_card) { Pile.new }
    let(:pile_with_card) { Pile.new([card]) }

    context 'card is in pile' do
      subject { pile_with_card.remove(card) }
      it { is_expected.not_to include card }
      it { is_expected.to be_empty }
    end

    context 'card not in pile' do
      subject { pile_without_card.remove(card) }
      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'multiple cards in pile' do
      let(:card) { instance_double('Card', as_json: 'as') }
      let(:card2) { instance_double('Card', as_json: 'as') }
      let(:pile) { Pile.new([card, card, card2]) }
      subject { pile.remove(card) }
      before do
        allow(card).to receive(:as_json).and_return(card)
        allow(card2).to receive(:as_json).and_return(card)
      end
      it { is_expected.to eq(Pile.new([card, card2])) }
    end
  end
end
