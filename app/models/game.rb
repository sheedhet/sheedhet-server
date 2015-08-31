# class that represents a game of sheedhet, encapsulates an entire game for
# storage in database
#
class Game # < ActiveRecord::Base
  include JsonEquivalence

  attr_accessor :discard_pile,
                :draw_pile,
                :hand_size,
                :history,
                :players,
                :play_pile,
                :valid_turns

  def initialize(collection_type = Pile)
    @discard_pile = collection_type.new
    @draw_pile    = collection_type.new
    @history      = []    # SHOULD THIS BE EXPOSED WITH AN ENUMERATOR??
    @play_pile    = collection_type.new
    @valid_turns  = []
  end

  def as_json
    game_state.as_json
  end

  def game_state
    { discard_pile: discard_pile,
      draw_pile: draw_pile,
      hand_size: hand_size,
      players: players,
      play_pile: play_pile,
      valid_turns: valid_turns
    }
  end

  def started?
    max_possible_swaps = players.size
    return true if history.size > max_possible_swaps
    history.any? { |turn| turn.is_a? LayCards }
  end

  def player_has_played?(player)
    history.find do |turn|
      turn.position == player.position && turn.is_a?(LayCards)
    end.present?
  end
end
