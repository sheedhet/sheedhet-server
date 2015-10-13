# describes a turn to swap cards
class SwapCards < Turn
  ACTION = :swap_cards

  def valid?
    valid_cards? && hasnt_played_yet?
  end

  def valid_cards?
    cards = @player.cards
    [:face_up, :in_hand].all? do |target|
      cards[target].contains?(@play_cards[target])
    end
  end

  def execute
    [:face_up, :in_hand].permutation(2) do |target_a, target_b|
      @play_cards[target_a].each do |card|
        removed_card = @player.cards[target_a].remove(card)
        @player.cards[target_b].add(removed_card)
      end
    end
    # @player.save
  end

  private

  def hasnt_played_yet?
    !@game.player_has_played?(@player)
  end
end
