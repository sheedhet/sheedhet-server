class PlayExecutor
  class InvalidPlayError < StandardError; end

  attr_reader :game, :play

  def initialize(game:, play:)
    @game = game
    @play = play
  end

  def valid?
    game.valid_plays.any? { |valid_play| valid_play.contains?(play) }
  end

  # def valid_swap?
  #   game.valid_plays.any? do |valid_play|
  #     valid_play.position == play.position
  #   end
  #   [:in_hand, :face_up].all? do |pile_name|
  #     sult = player.cards[pile_name].contains?(play.hand[pile_name])
  #   end
  # end

  def execute!
    raise InvalidPlayError unless valid?
    send_cards_to_destination
    refill_hand
    clear_play_pile if four_of_a_kind_in_play? || ten_played?
    game.history.push(play: play) #, state: game.as_json)
    game.update_valid_plays!
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
    when :in_hand
      pickup_play_pile
    # when :discard_pile
      # clear_play_pile
      # shouldn't this be where players pick up the play pile??
    when :swap
      perform_swap
    end
  end

  def perform_swap
    # mark equal number of cards in hand and face up, swap their positions
    from_face_up = play.hand[:face_up]
    from_in_hand = play.hand[:in_hand]
    from_face_up.each { |c| player.cards.remove_from(target: :face_up, subject: c) }
    from_in_hand.each { |c| player.cards.add_to(target: :face_up, subject: c) }
    from_in_hand.each { |c| player.cards.remove_from(target: :in_hand, subject: c) }
    from_face_up.each { |c| player.cards.add_to(target: :in_hand, subject: c) }
  end

  def pickup_play_pile
    game.play_pile.each { |c| player.cards.add_to(target: :in_hand, subject: c) }
    game.play_pile = Pile.new
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
