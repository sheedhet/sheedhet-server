class FindValidTurns
  def for(game)
    @game = game
    @top_card = @game.play_pile.last
    @previous_position = game.history.last.try(:position) || 0
    find_starter unless game_started?
  end


  def game_started?
    @game.history.any? { |turn| turn.class != SwapCards }
  end

  def find_starter
    @game.players.min { |player| player.cards[:in_hand].min }
    @game.players.inject({}) do |hash,player|
      hash.merge player => player.cards[:in_hand].min
    end
  end

end
