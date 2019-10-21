class PlayExecutor
  class InvalidPlayError < StandardError; end

  attr_reader :game, :play

  def initialize(game_id:, play_params:)
    @game = GameStore.load(game_id)
    @play = Play.from_json(play_params.to_json)
  rescue JSON::ParserError
    raise InvalidPlayError
  end

  def valid?
    game.valid_plays.any? { |valid_play| valid_play.contains?(play) }


    # ##################################################################
    # SERIOUS PROBLEM WHERE WE CAN PLAY A KING FROM FACE_UP AS LONG AS
    # THERES ONLY OTHER KINGS IN IN_HAND!
    # WE MUST ENSURE THAT EITHER THE PLAY INCLUDES THE OTHER KINGS
    # OR THAT IN_HAND IS OTHERWISE EMPTY??
    # ##################################################################
  end

  def execute!
    raise InvalidPlayError unless valid?
    executed_play = perform_play
    game.history.push(play: play)
    game.update_valid_plays!
    game
  end

  protected

  def play_for_history
    play
  end

  def player
    @player ||= game.players.find { |p| p.position == play.position }
  end

  def perform_play
    play_from_player
    refill_hand
    clear_play_pile if four_of_a_kind_in_play? || ten_played?
    play
  end

  def play_from_player
    player.remove(play.hand)
    game.play_pile = game.play_pile + play.hand.all_cards
  end

  def refill_hand
    while player_in_hand_empty? && draw_pile_not_empty?
      player.add_to(target: :in_hand, subject: game.draw_pile.pop)
    end
  end

  def four_of_a_kind_in_play?
    return false if game.play_pile.size < 4
    last4 = game.play_pile.last(4)
    last4.all? { |c| c.face == last4[0].face }
  end

  def ten_played?
    !game.play_pile.empty? && game.play_pile.last.face == :'10'
  end

  def clear_play_pile
    game.discard_pile = game.discard_pile + game.play_pile
    game.play_pile = Pile.new
  end

  def player_in_hand_empty?
    player.cards[:in_hand] && player.cards[:in_hand].size < game.hand_size
  end

  def draw_pile_not_empty?
    !game.draw_pile.empty?
  end
end
