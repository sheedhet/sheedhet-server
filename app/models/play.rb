class Play
  def initialize(action:, game:, position:)
    @action = action
    @game = game
    @position = position
    @player = @game.players[position]
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
    raise ArgumentError, 'Not a valid Play' unless valid?
  end
end
