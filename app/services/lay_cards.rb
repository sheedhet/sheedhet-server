# Service facilitates a player laying card(s) from hand to play pile
class LayCards < Turn
  ACTION = :lay_cards
  VALID_FACES = %w(a, 4, 5, 6, 9, j, q, k)

  def execute
    @play_cards.each do |pile_name, pile|
      pile.each do |card|
        @game.play_pile.add @player.cards[pile_name].remove(card)
      end
    end
  end
end
