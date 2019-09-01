class FlipPlayExecutor < PlayExecutor
  def initialize(game_id:, play_params:)
    @game = GameStore.load(game_id)
    @play = @game.valid_plays.find do |valid_play|
      valid_play.position == play_params[:position].to_i &&
        valid_play.destination == play_params[:destination].to_sym
    end
  end

  def valid?
    !play.nil?
  end

  def perform_play
    player.remove(play.hand)
    player_cards_hash = player.cards.as_json
    cards_with_in_hand = { in_hand: [] }.merge(player_cards_hash)
    player.cards = Hand.from_json(cards_with_in_hand.to_json)
    player.add_to(target: :in_hand, subject: play.hand[:face_down].first)
    play
  end
end
