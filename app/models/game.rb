class Game #< ActiveRecord::Base
  include JsonEquivalence

  attr_accessor :discard_pile,
                :draw_pile,
                :hand_size,
                :history,
                :players,
                :play_pile,
                :valid_turns

  def initialize
    @discard_pile = Pile.new
    @draw_pile    = Pile.new
    @history      = []    # SHOULD THIS BE EXPOSED WITH AN ENUMERATOR??
    @play_pile    = Pile.new
    @valid_turns  = []
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
    history.any? { |turn| turn.class == LayCards }
  end

  def as_json
    game_state.as_json
  end

  # def find_initial_plays
  #   start_value = 4
  #   while valid_turns.empty?
  #     players.each do |player|
  #       valid = player.cards[:in_hand].select{|card| card.face == start_value.to_s}
  #       valid.each do |card|
  #         @valid_turns << { player: player, card: card }
  #       end
  #     end
  #     start_value += 1
  #   end
  # end

  # def valid_play?(play_request)
  #   # do a comparison of valid turns somehow
  #   play_request[:action] == 'swap' &&
  #     hasnt_played_yet?(play_request[:player]) &&
  #     valid_swap?
  # end


end
