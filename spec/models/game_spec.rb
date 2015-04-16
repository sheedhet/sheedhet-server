require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:game) { GameFactory.new.build }
  let!(:player) { game.players.sample }
  let(:valid_swap) do
    { action: 'swap',
      player: player,
      in_hand: player.cards[:face_up],
      face_up: player.cards[:in_hand]
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
    valid_swap.merge({player: Player.new})
  end

  describe '#valid_swap?' do
    context 'given valid input,' do
      subject { game.valid_swap? valid_swap }
      it { is_expected.to be true }
    end

    context 'given invalid cards,' do
      subject { game.valid_swap? swap_with_invalid_cards }
      it { is_expected.to be false }
    end

    context 'given invalid action,' do
      subject { game.valid_swap? swap_with_invalid_action }
      it { is_expected.to be false }
    end

    context 'given invalid player,' do
      subject { game.valid_swap? swap_with_invalid_player }
      it { is_expected.to be false }
    end
  end

  describe '#hasnt_played_yet' do
    context 'player has not played,' do
      subject { game.hasnt_played_yet? player }
      it { is_expected.to be true }
    end

    context 'player has played,' do
      subject do
        game.history << { player: player, action: 'example' }
        game.hasnt_played_yet? player
      end
      it { is_expected.to be false }
    end
  end
end
