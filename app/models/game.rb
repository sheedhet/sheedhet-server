# class that represents a game of sheedhet, encapsulates an entire game for
# storage in database
#
class Game
  include JsonEquivalence

  VALID_CARD_PLAYS = {
    :'2' => ->(c) { true },
    :'4' => ->(c) { true },
    :'5' => ->(c) { c.value >= 5 },
    :'6' => ->(c) { c.value >= 6 },
    :'7' => ->(c) { c.value <= 7 || %i(2 3).include?(c.face) },
    :'8' => ->(c) { c.value >= 8 },
    :'9' => ->(c) { c.value >= 9 },
    :'10' => ->(c) { c.value >= 10 },
    j: ->(c) { c.value >= 11 },
    q: ->(c) { c.value >= 12 },
    k: ->(c) { c.value >= 13 },
    a: ->(c) { c.value >= 14 }
  }.freeze

  attr_accessor :discard_pile,
                :draw_pile,
                :hand_size,
                :history,
                :players,
                :play_pile,
                :valid_plays,
                :id

  def initialize(deck:, players:, hand_size:, collection_type: Pile)
    @discard_pile = collection_type.new
    @draw_pile    = deck
    @history      = []
    @play_pile    = collection_type.new
    @valid_plays  = []
    @players      = players
    @hand_size    = hand_size
  end

  def as_json
    game_state.as_json
  end

  def to_json
    as_json.to_json
  end

  def game_state
    {
      discard_pile: discard_pile,
      draw_pile: draw_pile,
      hand_size: hand_size,
      history: history,
      players: players,
      play_pile: play_pile,
      valid_plays: valid_plays
    }
  end

  def update_valid_plays!
    @valid_plays = valid_swaps + mid_game_plays + opening_plays + face_down_plays
  end

  # protected

  def face_down_plays
    return [] unless started? && next_to_play.only_face_down_cards?
    next_to_play.cards[:face_down].map.with_index do |face_down_card, i|
      Play.new(
        position: next_to_play.position,
        hand: Hand.new({ face_down: [face_down_card] }),
        destination: :"flip#{i}"
      )
    end
  end

  def mid_game_plays
    return [] unless started?
    mid_game_plays = valid_plays_for_next_player
    last_turn_pickup = last_turn[:play].pick_up_play?
    last_turn_flip = last_turn[:play].flip_play?
    last_turn_ten = last_turn[:play].ten_play?
    no_continuation_plays = last_turn_pickup || last_turn_ten || last_turn_flip
    unless no_continuation_plays
      continuation_plays = last_to_play.plays.select do |play|
        play.face == last_turn[:play].face
      end
      mid_game_plays += continuation_plays
    end
    mid_game_plays
  end

  def valid_plays_for_next_player
    valid_plays_for_next_player = next_to_play.plays.select do |play|
      card_valid_to_play?(play.first_card)
    end
    valid_plays_for_next_player.push(pick_up_the_pile_play) unless play_pile.empty?
    valid_plays_for_next_player
  end

  def card_valid_to_play?(card)
    return true if card_to_beat.nil?
    VALID_CARD_PLAYS[card_to_beat.face].call(card)
  end

  def card_to_beat
    play_pile.reverse.find { |c| c.face != :'3' }
  end

  def pick_up_the_pile_play
    Play.new(
      position: next_to_play.position,
      hand: Hand.new,
      destination: :in_hand
    )
  end

  def swap_play_for_position(position)
    player = players.find { |p| p.position == position }
    Play.new(
      position: position,
      hand: Hand.new(
        face_up: player.cards[:face_up],
        in_hand: player.cards[:in_hand]
      ),
      destination: :swap
    )
  end

  def opening_plays
    return [] if started?
    all_min_plays = players.each_with_object([]) do |player, min_plays|
      plays = player.plays
      smallest_play = plays.min_by(&:value)
      min_plays << smallest_play
    end
    min_value_play = all_min_plays.min_by(&:value)
    all_min_plays.select { |play| play.value == min_value_play.value }
  end

  def valid_swaps
    swaps, plays = history.partition { |turn| turn[:play].destination == :swap }
    swapped_positions = swaps.map { |turn| turn[:play].position }
    played_positions = plays.map { |turn| turn[:play].position }
    all_positions = (0..players.size.pred).to_a
    unswapped_positions = all_positions - swapped_positions - played_positions
    unswapped_positions.map { |position| swap_play_for_position(position) }
  end

  def last_turn
    history.reverse.find { |play| play[:play].destination != :swap } || {}
  end

  def last_to_play
    players.find do |player|
      player.position == last_turn[:play].position
    end
  end

  def four_of_a_kind_played_last?
    discard_pile.last(4).all? { |c| c.face == discard_pile.last.face }
  end

  def last_play_cleared_pile?
    play_pile.empty? &&
      !history.empty? &&
        (four_of_a_kind_played_last? || discard_pile.last.face == :'10')
  end

  def last_to_play_picked_up?
    last_turn[:play].pick_up_play? &&
      last_turn[:play].position == last_to_play.position
  end

  def next_to_play
    return last_to_play if last_turn[:play].flip_play?
    last_plays_again =
      last_play_cleared_pile? && !last_to_play_picked_up? && last_to_play.has_cards?
    return last_to_play if last_plays_again
    next_position = last_to_play.position.next % players.size
    while next_position != last_to_play.position do
      next_player = players.find { |player| player.position == next_position }
      break if next_player.has_cards?
      next_position = next_position.next % players.size
    end
    raise ArgumentError, "why isn't there a next_to_play?" if next_player.nil?
    next_player
  end

  def swaps_completed?
    history.count { |turn| turn[:play].swap_play? } == players.size
  end

  def started?
    history.reject { |turn| turn[:play].swap_play? }.any?
  end
end
