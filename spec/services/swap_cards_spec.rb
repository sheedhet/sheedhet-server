require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/services/turn.rb'
require_relative '../../app/services/swap_cards.rb'
require_relative '../../app/models/player.rb'
require_relative '../../app/models/hand.rb'
require_relative '../../app/models/pile.rb'
require_relative '../../app/models/card.rb'
require_relative '../../app/models/game.rb'
require_relative '../../app/services/lay_cards.rb'
require_relative '../../app/services/game_factory.rb'

RSpec.describe SwapCards do
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.sample }
  let(:action) { SwapCards::ACTION }
  let(:position) { player.position }
  let(:in_hand) { player.cards[:in_hand].sample(game.hand_size - 1) }
  let(:face_up) { player.cards[:face_up].sample(game.hand_size - 1) }
  let(:swap_cards) do
    Turn.build(
      action: action,
      play_cards: Hand.new(face_up: face_up, face_down: [], in_hand: in_hand),
      game: game,
      position: position
    )
  end
  let(:lay_cards_turn) do
    Turn.build(
      action: LayCards::ACTION,
      game: game,
      position: position
    )
  end

  describe '#valid?' do
    subject { swap_cards.valid? }

    context 'given valid input,' do
      it { is_expected.to be true }
    end

    context 'given invalid cards,' do
      let(:in_hand) { player.cards[:face_down] }
      it { is_expected.to be false }
    end

    context 'player has not played yet' do
      it { is_expected.to be true }
    end

    context 'player has already played' do
      before { game.history << lay_cards_turn }
      it { is_expected.to be false }
    end
  end

  describe '#execute' do
    subject { player.cards }
    let!(:correct_result) do
      Hand.new(
        in_hand: Pile.new(player.cards[:in_hand] - in_hand + face_up),
        face_up: Pile.new(player.cards[:face_up] - face_up + in_hand),
        face_down: Pile.from_json(player.cards[:face_down].as_json.to_s)
      )
    end
    before do
      require 'pry'
      # binding.pry
      swap_cards.execute
    end
    it { is_expected.to eq(correct_result) }
  end

  describe '#hasnt_played_yet?' do
    subject { swap_cards.send :hasnt_played_yet? }

    context 'has not played' do
      it { is_expected.to eq true }
    end

    context 'has played' do
      before { game.history << lay_cards_turn }
      it { is_expected.to eq false }
    end
  end
end
