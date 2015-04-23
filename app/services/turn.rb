class Turn
  def initialize(action:, game:, position:)
    @action = action
    @game = game
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
