class Turn
  def initialize(
    action:,
    from_face_down: [],
    from_face_up: [],
    from_in_hand: [],
    game:,
    position:
  )
    @action = action
    @from_face_down = from_face_down
    @from_face_up = from_face_up
    @from_in_hand = from_in_hand
    @game = game  # pull game from db
    @position = position
    @player = @game.players[position]
    @action.camelize.constantize.new
  end

  def ==(other_game)
    other_game.class == self.class && other_game.as_json == as_json
  end

  alias_method :eql?, :==

  def hash
    as_json.hash
  end

  def as_json
    { action: @action,
      game: @game,
      position: @position
    }
  end

  def valid?
    false
  end

  def execute
    raise ArgumentError, 'Not a valid Turn' unless valid?
  end
end
