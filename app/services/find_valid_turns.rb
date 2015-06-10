class FindValidTurns
  def self.for(game)
    self.new(game)
  end

  def initialize(game)
    @game = game
  end


  def find_starter
    @game.players.map do |player|
      player.get_starter
    end.min
  end

  def next_play_value
    valid_turns << @game.started? ? find_next_value : find_starter.value
  end

  def last_card_played  # move to Game class
    @last_card_played ||= @game.play_pile.last
  end

  def find_next_value
    last_played = last_card_played
    case last_played.face
    when ['4', '5', '6', '7', '8', '9', 'j', 'q', 'k', 'a']
      last_played.value
    when '2'
      4
    when '3'
      # scan for previous non-three value
    end
  end

  # def find_starter_turns
  #   @game.players.map do |player|
  #     starters = player.get_playable(
  #       operator: :==,
  #       value: find_starter.value
  #     )
  #     Turn.build(
  #       action: :lay_cards,
  #       game: @game,
  #       play_cards: starters,
  #       position: player.position
  #     )
  #   end.compact
  # end
  #
  # def figure_out_everything
  #   return find_starters unless game_started?
  #   find_quick_plays
  # end

  # def previous_play
  #   @previous_play ||= @game.history.reverse.find { |turn| turn.is_a? LayCards }
  # end
  #

  # def find_quick_plays
  #   player = @game.players[previous_play.position]
  #   playable_cards = find_playable_cards(player)
  #   playable_cards.find { |card| card.face == last_card_played.face }
  # end

  # def find_playable_cards(player)
  #   return player.cards[:in_hand] unless player.cards[:in_hand].empty?
  #   player.cards[:face_up]
  # end

  # def find_playable_duplicates(play)
  #   # figure out how to find all playable duplicates after we've figured out
  #   # what the applicable values are??
  # end
  #
  # def add_starters
  #   find_starters.each { |starter| make_play(starter) }
  # end
  #
  # def previous_play
  #   @game.history.last
  # end
  #
  # def find_turn_multiples(turn)
  #   # this is where we figure out where the extra duplicate turns should be?
  # end

  #
  # def find_starters
  #   @game.players.inject([]) do |starters, player|
  #     valid_cards = player.cards[:in_hand].select do |card|
  #       card.value == min_value
  #     end
  #
  #     starters << Turn.new(
  #       action: LayCards::ACTION,
  #       position: player.position,
  #       play_cards: { in_hand: valid_cards }
  #     ) unless valid_cards.empty?
  #   end
  # end
end
