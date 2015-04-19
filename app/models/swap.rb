class Swap < Play
  def initialize(action: 'swap', game:, position:, to_face_up:, to_in_hand:)
    super(action: action, game: game, position: position)
    @to_face_up = to_face_up
    @to_in_hand = to_in_hand
  end

  def as_json
    super.merge{
      { to_face_up: @to_face_up,
        to_in_hand: @to_in_hand
      }
    }
  end

  def valid?
    cards       = @player.cards
    from_play   = (@to_in_hand + @to_face_up).sort
    from_player = (cards[:in_hand] + cards[:face_up]).sort
    hand_size   = @game.hand_size
    valid = {
      action: @action == 'swap',
      cards: from_play == from_player,
      hasnt_played: hasnt_played_yet?,
      size: [@to_in_hand, @to_face_up].all? { |x| x.size == hand_size },
    }
    valid.values.all?
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
      old_play[:position] == @player.position && old_play[:action] != 'swap'
    end.empty?
  end

end
