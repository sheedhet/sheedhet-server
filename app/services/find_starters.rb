class FindStarters
  def self.for(game)
    self.new(game)
  end

  def initialize(game)
    @game = game
  end

  def find_starter_value
    @game.players.map { |player| player.cards[:in_hand].min }.min.value
  end

  def players_who_can_start
    @game.players.select { |player| player }
  end

end
