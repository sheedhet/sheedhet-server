require 'rails_helper'

RSpec.describe SwapCards do
  let!(:game) { GameFactory.new.build }
  let!(:player) { game.players.sample }
  let!(:action) { 'swap_cards' }
  let!(:position) { player.position }
  let!(:to_in_hand) { player.cards[:face_up] }
  let!(:to_face_up) { player.cards[:in_hand] }
  let!(:swap) do
    SwapCards.new(
      action: action,
      game: game,
      position: position,
      to_in_hand: to_in_hand,
      to_face_up: to_face_up
    )
  end

  describe '#valid?' do
    subject { swap.valid? }

    context 'given valid input,' do
      it { is_expected.to be true }
    end

    context 'given invalid cards,' do
      let!(:to_in_hand) { player.cards[:in_hand] }
      it { is_expected.to be false }
    end

    context 'given invalid action,' do
      let!(:action) { 'invalid' }
      it { is_expected.to be false }
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
    # to do
  end
end
