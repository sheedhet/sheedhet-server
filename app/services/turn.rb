class Turn
  include Equivalence

  attr_reader :position

  def self.build(
    action:,
    game:,
    play_cards: Player::PILES.inject({}){ |hash, pile| hash.merge(pile => []) },
    position:
  )
    klass = action.to_s.camelize.constantize
    klass.new(
      action: action,
      game: game,
      play_cards: play_cards,
      position: position
    )
  end

  def initialize(
    action:,
    game:,
    play_cards:,
    position:
  )
  @action = action
  @game = game  # pull game from db
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
    @game.valid_plays.include? self
  end

  def execute
    raise ArgumentError, 'Not a valid Turn' unless valid?
  end
end
