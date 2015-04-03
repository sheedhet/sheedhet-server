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
    play_request[:action] == 'swap' &&
      hasnt_played_yet?(play_request[:player]) &&
      valid_swap_cards?
  end

  def valid_swap_cards?(play_request)
    player = play_request[:player]
    from_request = (play_request[:in_hand] + play_request[:face_up]).sort
    from_player = (player.cards[:in_hand] + player.cards[:face_up]).sort
    from_request == from_player &&
      play_request[:in_hand].size == hand_size &&
      play_request[:face_up].size == hand_size
  end

  def hasnt_played_yet?(player)
    history.select do |old_play|
      old_play[:player] == player && old_play[:action] != 'swap'
    end.empty?
  end

  def valid_cards?(play_request)
    player = play_request[:player]

    # player.cards.each do |target, pile|
      # from_play_request = play_request.fetch(target, false)
      # if from_play_request
        # bleh
      # end
    # end

    [:in_hand, :face_up, :face_down].all? do |target|
      target_pile = Array(play_request.fetch(target, []))
      target_pile.inject([]) do |pile, card|
        index = player.cards[target].index(card)
        pile << player.cards[target][index] if index
        pile
      end.size == target_pile.size
    end
  end


  # def valid_plays_as_json
  #   @valid_plays#.map do |play|
  #     # { player: play[:player].name, card: play[:card] }
  #   # end
  # end

end
