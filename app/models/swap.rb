class Swap < Play
  def initialize(action: :swap, game:, player:, to_face_up:, to_in_hand:)
    super
    @to_face_up = to_face_up
    @to_in_hand = to_in_hand
  end

  def valid?
    player      = @game.players[@player.position]
    cards       = @player.cards
    from_play   = (@to_in_hand + @to_face_up).sort
    from_player = (cards[:in_hand] + cards[:face_up]).sort
    valid = {
      cards: from_play == from_player,
      size: [play[:in_hand], play[:face_up]].all? { |x| x.size == hand_size },
      action: play[:action] == 'swap',
      player: play[:player] == player
    }
    hasnt_played_yet?(@player) && valid.values.all?
  end

  def execute
    super
    @player.cards[:in_hand] = @to_in_hand
    @player.cards[:face_up] = @to_face_up
    # @player.save
  end

  protected

  def hasnt_played_yet?
    @game.history.select do |old_play|
      old_play[:player] == @player && old_play[:action] != 'swap'
    end.empty?
  end

end
