require 'rails_helper'

RSpec.describe FindValidTurns do
  let(:game) { GameFactory.new.build }

  describe '#find_starter:' do
    context 'when nobody has played yet,' do
      context 'when only one player can play' do
        subject { game.valid_turns.last }
        # it { is_expected.not_to eq(correct_turn) }
      end
    end
  end
end
