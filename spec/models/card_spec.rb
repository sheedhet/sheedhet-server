require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/models/card.rb'

RSpec.describe Card do
  describe '.random_card' do
    subject { Card.random_card }

    it { is_expected.to be_a(Card) }
  end

  describe '.from_json' do
    subject { Card.from_json('ah') }
    it { is_expected.to eq(Card.new(face: 'a', suit: 'h')) }
  end

  describe '#<=>' do
    let(:small_face) { '4' }
    let(:large_face) { '10' }
    let(:subject_card) { Card.new face: subject_face }
    let(:other_suit) { subject_card.suit }
    let(:other_card) { Card.new face: other_face, suit: other_suit }

    subject { subject_card <=> other_card }

    context 'other card is larger' do
      let(:other_face) { large_face }
      let(:subject_face) { small_face }
      it { is_expected.to eq(-1) }
    end

    context 'other card is smaller' do
      let(:other_face) { small_face }
      let(:subject_face) { large_face }
      it { is_expected.to eq 1 }
    end

    context 'other card is same' do
      let(:other_face) { large_face }
      let(:subject_face) { large_face }
      context 'with same suit' do
        it { is_expected.to be_zero }
      end

      context 'with different suit' do
        let(:other_suit) { Card::SUITS.find { |s| s != subject_card.suit } }
        it { is_expected.to eq(1).or eq(-1) }
      end
    end
  end

  describe '#value' do
    subject { Card.new(face: face).value }
    context 'face not in Card::VALUES' do
      let(:face) { '4' }
      it { is_expected.to eq(face.to_i) }
    end

    context 'face in Card::VALUES' do
      let(:face) { 'a' }
      it { is_expected.to eq(Card::VALUES[face]) }
    end
  end

  describe '#as_json' do
    let(:card) { Card.new }
    subject { card.as_json }
    it { is_expected.to eq("#{card.face}#{card.suit}") }
  end
end
