class Turn
  include Equivalence

  def self.build(
    action:,
    game:,
    play_cards: Player::PILES.inject({}){ |hash, pile| hash.merge(pile => []) },
    position:
  )
    klass = action.camelize.constantize
    klass.new(
      game: game,
      play_cards: play_cards,
      position: position
    )
  end

  def initialize(
    game:,
    play_cards:,
    position:
  )
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
