class GameStarter
  def self.start(game)
    self.new(game)
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

  def playable_cards_for(player)
    player.get_playable(operator: :>=, value: find_starter.value)
  end

  def create_starter_turns
    starter_turns = @game.players.inject([]) do |results,player|
      results << TurnFactory.for(playable_cards_for(player))
    end
    @game.valid_turns << starter_turns.compact
  end
end
