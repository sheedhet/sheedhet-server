require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/card.rb'
require_relative '../../app/models/hand.rb'
require_relative '../../app/models/pile.rb'
require_relative '../../app/models/player.rb'
require_relative '../../app/models/game.rb'
require_relative '../../app/services/game_factory.rb'
require_relative '../../app/services/turn.rb'
require_relative '../../app/services/lay_cards.rb'
require 'pry'

RSpec.describe LayCards do
  let(:game) { GameFactory.new.build }
  let(:player) { game.players.sample }
  let(:hand) { player.cards }
  let(:action) { LayCards::ACTION }
  let(:position) { player.position }
  let(:target) { hand.container_names.sample }
  let(:played_cards) { Hand.new }
  let(:random_card) { hand[target].sample }
  before { played_cards.add_to target: target, subject: random_card }

  let(:lay_card) do
    Turn.build(
      action: action,
      game: game,
      play_cards: played_cards,
      position: position
    )
  end

  describe '#execute' do
    before { lay_card.execute }
    it { expect(player.cards[target]).not_to include random_card }
    it { expect(game.play_pile.pop).to eq random_card }
  end
end
