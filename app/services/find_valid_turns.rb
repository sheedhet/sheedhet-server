# service to find all valid plays for the existing game state
class FindValidTurns
  def self.for(game)
    new(game)
  end

  def initialize(game)
    @game = game
  end

  def next_play_value
    valid_turns << @game.started? ? find_next_value : find_starter.value
  end

  def last_card_played
    @last_card_played ||= @game.play_pile.last
  end

  def last_face_played
    last_card_played.face
  end

  def params_to_get_next_valid
    operator = :>=
    case last_card_played.face
    when '2'
      value = 3
    when '3'
      value = @game.play_pile.rindex { |card| card.face != '3' }.value
    when '7'
      operator = :<=
    end
    { operator: operator, value: value }
  end

  def find_all_playable(operator:, value:)
    @game.players.each_with_object({}) do |player, result|
      result[player] = player.get_playable(operator: operator, value: value)
    end
    playable
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
  # @previous_play ||= @game.history.reverse.find { |turn| turn.is_a? LayCards }
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
  #   @game.players.reduce([]) do |starters, player|
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
