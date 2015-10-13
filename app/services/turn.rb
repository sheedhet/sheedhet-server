# Superclass for all Turn types
#
class Turn
  include JsonEquivalence
  require 'active_support/inflector' # for String#camelize

  attr_reader :position

  def self.build(action:, game:, play_cards: Hand.new, position:)
    klass = action.to_s.camelize.constantize
    klass.new(
      action: action,
      game: game,
      play_cards: play_cards,
      position: position
    )
  end

  def initialize(action:, game:, play_cards:, position:)
    @action = action
    @game = game # pull game from db
    @play_cards = play_cards
    @position = position
    @player = @game.players[position]
  end

  def as_json
    { action: @action.as_json,
      game: @game.as_json,
      play_cards: @play_cards.as_json,
      position: @position.as_json
    }
  end

  def valid?
    @game.valid_turns.include?(self)
  end

  def execute
    fail ArgumentError, 'Not a valid Turn' unless valid?
  end
end
