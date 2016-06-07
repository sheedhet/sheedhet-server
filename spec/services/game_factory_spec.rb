require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/card.rb'
require_relative '../../app/models/pile.rb'
require_relative '../../app/models/hand.rb'
require_relative '../../app/models/player.rb'
require_relative '../../app/models/game.rb'
require_relative '../../app/services/deck_factory.rb'
require_relative '../../app/services/card_dealer.rb'
require_relative '../../app/services/game_factory.rb'

RSpec.describe GameFactory do
  let(:state) { {} }
  let(:deck_factory) { class_double('DeckFactory', build: DeckFactory.build) }
  let(:card_dealer) { class_double('CardDealer', deal: true) }
  let(:game_factory) do
    GameFactory.new(
      state: state,
      classes: {
        deck_factory: deck_factory,
        card_dealer: card_dealer
      }
    )
  end
  let(:game) { game_factory.create_new_game }

  describe '#create_new_game' do
    subject { game }

    it { is_expected.to be_a(Game) }

    it 'creates the correct number of players' do
      expect(subject.players.size).to eq(
        GameFactory::DEFAULT_OPTIONS[:num_players]
      )
    end

    it 'signals DeckFactory to build a deck' do
      expect(deck_factory).to receive(:build)
      subject
    end

    it 'signals CardDealer to deal cards' do
      expect(card_dealer).to receive(:deal)
      subject
    end
  end
end
