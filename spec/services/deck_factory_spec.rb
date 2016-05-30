require 'spec_helper'
require_relative '../../app/services/deck_factory.rb'

RSpec.describe DeckFactory do
  let(:suits) { %w(c d h) }
  let(:faces) { %w(2 8 k a) }
  let(:card_class) { class_double('Card', suits: suits) }
  let(:card) { instance_double('Card') }

  before do
    allow(card_class).to receive(:suits).and_return(suits)
    allow(card_class).to receive(:faces).and_return(faces)
    allow(card_class).to receive(:new)
      .with(hash_including(suit: anything, face: anything))
      .and_return(card)
  end

  describe '.build' do
    let(:multiplier) { 3 }
    subject { DeckFactory.build(multiplier, card_class).size }
    it { is_expected.to eq(suits.size * faces.size * multiplier) }
  end

  describe '#create_deck' do
    subject { DeckFactory.new(card_class).create_deck }
    it { expect(subject.size).to eq(suits.size * faces.size) }
    it { is_expected.to all(eq(card)) }
  end
end
