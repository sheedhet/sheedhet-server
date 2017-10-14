# class that represents a game of sheedhet, encapsulates an entire game for
# storage in database
#
class Game
  include JsonEquivalence

  VALID_CARD_PLAYS = {
    '2' => -> { true },
    '4' => -> { true },
    '5' => ->(c) { c.value >= 5 },
    '6' => ->(c) { c.value >= 6 },
    '7' => ->(c) { c.value <= 7 || %w(2 3).include?(c.face) },
    '8' => ->(c) { c.value >= 8 },
    '9' => ->(c) { c.value >= 9 },
    'j' => ->(c) { c.value >= 11 },
    'q' => ->(c) { c.value >= 12 },
    'k' => ->(c) { c.value >= 13 },
    'a' => ->(c) { c.value >= 14 }
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
    { discard_pile: discard_pile,
      draw_pile: draw_pile,
      hand_size: hand_size,
      history: history,
      players: players,
      play_pile: play_pile,
      valid_plays: valid_plays }
  end

  def update_valid_plays
    @valid_plays =
      if started?
        find_mid_game_plays
      else
        find_first_plays
      end
  end

  protected

  def find_mid_game_plays
    card_to_play_on = play_pile.reverse.find { |c| c.face != '3' }

    players_who_can_play.each do |player|
      plays = player.plays
      valid_plays[player] = plays.select do |desc, _|
        VALID_CARD_PLAYS[card_to_play_on.face].call(desc)
      end
    end
  end

  def find_first_plays
    all_min_plays = players.each_with_object([]) do |player, result|
      plays = player.plays
      smallest_play = plays.min_by(&:value)
      result << smallest_play
    end
    min_value_play = all_min_plays.min_by(&:value)
    all_min_plays.select { |play| play.value == min_value_play.value }
  end

  def players_who_can_play
    return players if history.empty?
    last_turn = history.last
    last_to_play = last_turn.player
    next_to_play = players.select do |player|
      player.position = last_to_play.position.next % players.size
    end
    [last_to_play, next_to_play]
  end

  def started?
    max_possible_swaps = players.size
    return true if history.size > max_possible_swaps
    turns_grouped_by_player = history.group_by(&:player)
    turns_grouped_by_player.any? { |_, turns| turns.size > 1 }
  end
end
