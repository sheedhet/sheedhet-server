require 'rails_helper'

RSpec.describe Card do
  let(:small_face) { '4' }
  let(:subject_face) { '8' }
  let(:large_face) { '10' }
  let(:suit) { Card::SUITS.sample }
  let(:other_card) { Card.new face: other_face, suit: suit }
  let(:subject_card) { Card.new face: subject_face, suit: suit }

  describe '#<=>' do
    subject { subject_card <=> other_card }

    context 'other card is larger' do
      let(:other_face) { large_face }
      it { is_expected.to eq(-1) }
    end

    context 'other card is smaller' do
      let(:other_face) { small_face }
      it { is_expected.to eq 1 }
    end

    context 'other card is same' do
      let(:other_face) { subject_face }
      it { is_expected.to eq 0 }
    end
  end
end
