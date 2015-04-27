class SwapCards < Turn
  ACTION = 'swap_cards'

  def valid?
    valid_cards? && hasnt_played_yet?
  end

  def valid_cards?
    cards = @player.cards
    valid_face_up = cards[:face_up].select { |c| @from_face_up.include? c }
    valid_in_hand = cards[:in_hand].select { |c| @from_in_hand.include? c }
    matches_face_up = valid_face_up.sort == @from_face_up.sort
    matches_in_hand = valid_in_hand.sort == @from_in_hand.sort
    matches_face_up && matches_in_hand

    # @from_in_hand.select? { |card| cards[:in_hand].include? card }
    # @from_face_up.all? { |card| cards[:face_up].include? card }
    # from_turn   = (@from_in_hand + @from_face_up).sort
    # from_player = (cards[:in_hand] + cards[:face_up]).sort
    # from_turn == from_player
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

  def hasnt_played_yet?
    @game.history.select do |old_turn|
      old_turn[:position] == @player.position && old_turn[:action] != ACTION
    end.empty?
  end

end
