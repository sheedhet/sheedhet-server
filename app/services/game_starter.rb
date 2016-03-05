# service responsible for handling the beginning of a game
#
class CreateEligibleStarterTurns
  def self.for(game)
    new(game)
    create_starter_turns
  end

  def initialize(game)
    @game = game
    create_starter_turns
  end

  def find_starter
    @game.players.map(&:lowest_card).min
  end

  def create_starter_turns
    # @game.players.reduce([]) do |results, player|
    #   results << TurnFactory.for(player: player, operator: :>=, game: @game)
    # end

    # replace this with the new shit

    @game.players.each_with_object([]) do |player, results|
      results << TurnFactory.for(player: player, operator: :>=, game: @game)
    end
  end
end
