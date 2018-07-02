class PlayExecutor
  class InvalidPlayError < StandardError; end

  attr_reader :game, :play

  def initialize(game:, play:)
    @game = game
    @play = play
  end

  def valid?
    if play.destination == :swap
      valid_swap?
    else
      game.valid_plays.any? { |valid_play| valid_play.contains?(play) }
      # #############################################################
      # I think with the inclusion of a :contains? chain of methods,
      # we're good to go with the valid play detection and perhaps
      # this is good enough to get us on to whatever the next step
      # is. Unfortunately it looks like our docker aint working no
      # more so maybe now's the time to do a full migration to the
      # latest and greatest platform tech?!
      # - new rails
      # - new docker bs
      # - new webpacker bs
      # - new etc bs
      # #############################################################
    end
  end

  def valid_swap?
    game.valid_plays.any? do |valid_play|
      valid_play.position == play.position
    end
    [:in_hand, :face_up].all? do |pile_name|
      player.hand[pile_name].contains?(play.hand[pile_name])
    end
  end

  def execute!
    raise InvalidPlayError unless valid?
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
      clear_play_pile
    when :swap
      perform_swap
    end
  end

  def perform_swap
    # mark equal number of cards in hand and face up, swap their positions
    from_face_up = play.hand[:face_up]
    from_in_hand = play.hand[:in_hand]
    player.hand[:face_up] -= from_face_up
    player.hand[:face_up] += from_in_hand
    player.hand[:in_hand] -= from_in_hand
    player.hand[:in_hand] += from_face_up
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
