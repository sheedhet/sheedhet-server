require 'rails_helper'

RSpec.describe SheedhetGame, type: :model do
  subject(:game) { SheedhetGameFactory.new.build }
  let(:player) { game.players.sample }
  let(:valid_swap) do
    { action: 'swap',
      player: player,
      in_hand: player.cards[:in_hand],
      face_up: player.cards[:face_up]
    }
  end

  let(:swap_with_invalid_cards) do
    valid_swap.merge(
      { in_hand: player.cards[:face_down],
        face_up: player.cards[:face_up]
      }
    )
  end

  let(:swap_with_invalid_action) { valid_swap.merge({action: 'invalid'}) }

  let(:swap_with_invalid_player) do
    valid_swap.merge({player: SheedhetPlayer.new})
  end

  describe '#valid_swap?' do
    context 'given valid input, returns true' do
      it { expect(game.valid_swap?(valid_swap)).to be true }
    end

    context 'given invalid cards, returns false' do
      it { expect(game.valid_swap?(swap_with_invalid_cards)).to be true }
    end

    context 'given invalid action, returns false' do
      it { expect(game.valid_swap?(swap_with_invalid_action)).to be true }
    end

    context 'given invalid player, returns false' do
      it { expect(game.valid_swap?(swap_with_invalid_player)).to be true }
    end
  end

end
