require 'rails_helper'

RSpec.describe SwapCards do
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.sample }
  let(:action) { SwapCards::ACTION }
  let(:position) { player.position }
  let(:from_in_hand) { player.cards[:in_hand].dup }
  let(:from_face_up) { player.cards[:face_up].dup }
  let(:swap) do
    Turn.build(
      action: action,
      from_face_up: from_face_up,
      from_in_hand: from_in_hand,
      game: game,
      position: position
    )
  end

  describe '#valid?' do
    subject { swap.valid? }

    context 'given valid input,' do
      it { is_expected.to be true }
    end

    context 'given invalid cards,' do
      let(:from_in_hand) { player.cards[:face_down] }
      it { is_expected.to be false }
    end

    context 'given invalid action,' do
      let(:action) { 'invalid' }
      it { expect { swap }.to raise_error }
    end

    context 'player has not played yet' do
      it { is_expected.to be true }
    end

    context 'player has already played' do
      before { game.history << { position: position, action: 'play' } }
      it { is_expected.to be false }
    end
  end

  describe '#execute' do
    subject { player.cards }
    let(:correct_result) do
      { in_hand: from_face_up,
        face_up: from_in_hand,
        face_down: player.cards[:face_down]
      }
    end
    before { swap.execute }
    it { is_expected.to eq(correct_result)}
  end
end
