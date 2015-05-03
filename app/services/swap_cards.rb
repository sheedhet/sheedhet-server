class SwapCards < Turn
  ACTION = 'swap_cards'

  def valid?
    valid_cards? && hasnt_played_yet?
  end

  def valid_cards?
    cards = @player.cards
    [:face_up, :in_hand].all? do |target|
      valid = cards[target].select { |c| @play_cards[target].include? c }
      valid.sort == @play_cards[target].sort
    end
  end

  def execute
    [:face_up, :in_hand].permutation(2) do |target_a, target_b|
      @play_cards[target_a].each do |card|
        @player.cards[target_b].add @player.cards[target_a].remove(card)
      end
    end
    # @player.save
  end

  def hasnt_played_yet?
    @game.history.select do |old_turn|
      old_turn[:position] == @player.position && old_turn[:action] != ACTION
    end.empty?
  end

end
