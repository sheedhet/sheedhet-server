class GameStarter
  def self.start(game)
    new(game)
  end

  def initialize(game)
    @game = game
    create_starter_turns
  end

  def find_starter
    @game.players.map do |player|
      player.get_starter
    end.min
  end

  def create_starter_turns
    @game.players.inject([]) do |results, player|
      results << TurnFactory.for(player: player, operator: :>=, game: @game)
    end
  end
end
