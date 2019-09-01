class PickupPlayExecutor < PlayExecutor
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
    recreate_empty_player_pile if player.cards[:in_hand].nil?
    game.play_pile.each { |c| player.cards.add_to(target: :in_hand, subject: c) }
    game.play_pile = Pile.new
    play
  end

  protected

  def recreate_empty_player_pile
    old_cards = player.cards
    new_cards_hash = {in_hand: []}.merge(old_cards.as_json)
    player.cards = Hand.from_json(new_cards_hash.to_json)
  end
end
