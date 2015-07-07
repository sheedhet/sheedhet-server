# service determines who can start and with which cards?
class FindStarters
  def self.for(game)
    new(game)
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
