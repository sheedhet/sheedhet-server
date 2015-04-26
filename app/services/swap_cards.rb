class SwapCards < Turn
  ACTION = 'swap_cards'

  def as_json
    super.merge({ from_face_up: @from_face_up.as_json, from_in_hand: @from_in_hand.as_json })
  end

  def valid?
    [valid_cards?, hasnt_played_yet?, valid_size? ].all?
  end

  def valid_size?
    [@from_in_hand, @from_face_up].all? { |x| x.size == @game.hand_size }
  end

  def valid_cards?
    cards = @player.cards
    from_turn   = (@from_in_hand + @from_face_up).sort
    from_player = (cards[:in_hand] + cards[:face_up]).sort
    from_turn == from_player
  end

  def execute
    @from_in_hand.each do |card|
      @player.add_to_face_up @player.remove_from_hand(card)
    end
    @from_face_up.each do |card|
      @player.add_to_hand @player.remove_from_face_up(card)
    end
    true
    # @player.save
  end

  protected

  def hasnt_played_yet?
    @game.history.select do |old_turn|
      old_turn[:position] == @player.position && old_turn[:action] != ACTION
    end.empty?
  end

end
