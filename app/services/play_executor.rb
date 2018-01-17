class PlayExecutor
  class InvalidPlayError < StandardError; end

  attr_reader :game, :play

  def initialize(game:, play:)
    @game = game
    @play = play
  end

  def valid?
    game.valid_plays.any? { |valid_play| valid_play == play }
  end

  def execute!
    raise InvalidPlayError unless valid?
    remove_cards_from_source
    send_cards_to_destination
    refill_hand
    clear_play_pile if four_of_a_kind_in_play?
    game.update_valid_plays!
    game.history.push(play: play, state: game.as_json)
    game
  end

  # protected

  def player
    @player ||= game.players.find { |p| p.position == play.position }
  end

  def send_cards_to_destination
    case play.destination
    when :play_pile
      play_from_player
    when :discard_pile
      clear_pile
    end
  end

  def pickup_play_pile
    player.hand[:in_hand] = player.hand[:in_hand] + game.play_pile
    game.play_pile = Pile.new
  end

  def play_from_player
    player.remove(play.hand)
    game.play_pile = game.play_pile + play.hand.all_cards
  end

  def refill_hand
    while player_needs_cards? && draw_pile_not_empty?
      player.add_to(target: :in_hand, subject: game.draw_pile.pop)
    end
  end

  def four_of_a_kind_in_play?
    return false if game.play_pile.size < 4
    fourth_card = game.play_pile[-4]
    game.play_pile.last(3).all? { |c| c.face == fourth_card.face }
  end

  def clear_play_pile
    game.discard_pile = game.discard_pile + game.play_pile
    game.play_pile = Pile.new
  end

  def player_needs_cards?
    player.cards[:in_hand].size < game.hand_size
  end

  def draw_pile_not_empty?
    !game.draw_pile.empty?
  end
end
