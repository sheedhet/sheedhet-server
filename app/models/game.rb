# class that represents a game of sheedhet, encapsulates an entire game for
# storage in database
#
class Game
  include JsonEquivalence

  VALID_CARD_PLAYS = {
    :'2' => -> { true },
    :'4' => -> { true },
    :'5' => ->(c) { c.value >= 5 },
    :'6' => ->(c) { c.value >= 6 },
    :'7' => ->(c) { c.value <= 7 || %w(2 3).include?(c.face) },
    :'8' => ->(c) { c.value >= 8 },
    :'9' => ->(c) { c.value >= 9 },
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
                :valid_plays

  attr_reader :id

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
    @valid_plays = valid_swaps + (started? ? mid_game_plays : opening_plays)
    # this method needs to be smarter, its more than tertiary:
    #  - swaps almost happen in parallel, but they also block turns
    #  - i think opening plays only describes one play, a special case
    #  - evaluate swaps independantly of turns list
    #  - add an easy optimization to checking for swaps, only check first x

    # i feel like i already completed the above, where did that go?
  end

  # protected

  def mid_game_plays
    mid_game_plays = valid_plays_for_next_player
    mid_game_plays += last_to_play.plays.select do |play|
      play.face == last_turn[:play].face
    end
    mid_game_plays
  end

  def valid_plays_for_next_player
    mid_game_plays = next_to_play.plays.select do |play|
      card_valid_to_play?(play.first_card)
    end
    mid_game_plays.push(pick_up_the_pile_play)
  end

  def card_valid_to_play?(card)
    return true if card_to_beat.nil?
    VALID_CARD_PLAYS[card_to_beat.face].call(card)
  end

  def card_to_beat
    play_pile.reverse.find { |c| c.face != '3' }
  end

  def pick_up_the_pile_play
    Play.new(
      position: next_to_play.position,
      hand: Hand.new({ play_pile: play_pile.all }, Pile, [:play_pile]),
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
    all_min_plays = players.each_with_object([]) do |player, min_plays|
      plays = player.plays
      smallest_play = plays.min_by(&:value)
      min_plays << smallest_play
    end
    min_value_play = all_min_plays.min_by(&:value)
    all_min_plays.select { |play| play.value == min_value_play.value }
  end

  def valid_swaps
    swaps, plays = history.partition { |turn| turn.play.destination == :swap }
    swapped_positions = swaps.map { |turn| turn.play.position }
    played_positions = plays.map { |turn| turn.play.position }
    all_positions = (0..players.size.pred).to_a
    unswapped_positions = all_positions - swapped_positions - played_positions
    unswapped_positions.map { |position| swap_play_for_position(position) }
  end

  def last_turn
    history.last
  end

  def last_to_play
    players.find do |player|
      player.position == last_turn[:play].position
    end
  end

  def next_to_play
    players.find do |player|
      player.position == last_to_play.position.next % players.size
    end
  end

  def swaps_completed?
    history.count { |turn| turn[:play].destination == :swap } == players.size
  end

  def started?
    history.reject { |turn| turn[:play].destination == :swap }.any?
  end
end
