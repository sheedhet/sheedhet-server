class SheedhetGame #< ActiveRecord::Base
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

  def valid_play?(play_request)
    # do a comparison of valid turns somehow
    play_request[:action] == 'swap' &&
      hasnt_played_yet?(play_request[:player]) &&
      valid_swap?
  end

  def valid_swap?(play)
    hasnt_played_yet?(play_request[:player]) && player.valid_swap?(play)
  end


  def hasnt_played_yet?(player)
    history.select do |old_play|
      old_play[:player] == player && old_play[:action] != 'swap'
    end.empty?
  end

end
