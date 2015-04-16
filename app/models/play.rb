class Play
  def initialize(player:, action:)
    @action = action
    @game = game
    @player = player
  end

  def valid?
    false
  end

  def execute
    raise ArgumentError, 'Not a valid Play' unless valid?
  end
end
