class Turn
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

  def ==(other_game)
    other_game.class == self.class && other_game.as_json == as_json
  end

  alias_method :eql?, :==

  def hash
    as_json.hash
  end

  def as_json
    { action: @action.as_json,
      game: @game.as_json,
      position: @position.as_json
    }
  end

  def valid?
    false
  end

  def execute
    raise ArgumentError, 'Not a valid Turn' unless valid?
  end
end
