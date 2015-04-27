class Turn
  include Equivalence

  def self.build(
    action:,
    from_face_down: [],
    from_face_up: [],
    from_in_hand: [],
    game:,
    position:
  )
    klass = action.camelize.constantize
    klass.new(
      from_face_down: from_face_down,
      from_face_up: from_face_up,
      from_in_hand: from_in_hand,
      game: game,
      position: position
    )
  end

  def initialize(
    from_face_down: [],
    from_face_up: [],
    from_in_hand: [],
    game:,
    position:
  )
  @from_face_down = from_face_down
  @from_face_up = from_face_up
  @from_in_hand = from_in_hand
  @game = game  # pull game from db
  @position = position
  @player = @game.players[position]
  end

  def as_json
    { action: @action.as_json,
      from_face_down: @from_face_down.as_json,
      from_face_up: @from_face_up.as_json,
      from_in_hand: @from_in_hand.as_json,
      game: @game.as_json,
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
