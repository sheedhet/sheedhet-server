class Game #< ActiveRecord::Base
  attr_accessor :discard_pile,
                :draw_pile,
                :hand_size,
                :history,
                :players,
                :play_pile,
                :valid_plays

  def initialize
    @discard_pile = []
    @draw_pile    = []
    @history      = []
    @play_pile    = []
    @valid_plays  = []
  end

  def ==(other_game)
    other_game.class == self.class && other_game.as_json == as_json
  end

  alias_method :eql?, :==

  def hash
    as_json.hash
  end

  def game_state
    { discard_pile: discard_pile,
      draw_pile: draw_pile,
      hand_size: hand_size,
      players: players,
      play_pile: play_pile,
      valid_plays: valid_plays
    }
  end

  def as_json
    game_state.as_json
  end

  # def find_initial_plays
  #   start_value = 4
  #   while valid_plays.empty?
  #     players.each do |player|
  #       valid = player.cards[:in_hand].select{|card| card.face == start_value.to_s}
  #       valid.each do |card|
  #         @valid_plays << { player: player, card: card }
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
