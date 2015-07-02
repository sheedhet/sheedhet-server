# Service facilitates a player laying card(s) from hand to play pile
class LayCards < Turn
  ACTION = :lay_cards
  VALID_FACES = %w(a, 4, 5, 6, 9, j, q, k)

  def execute
    # require 'pry'
    # binding.pry

    @play_cards.each do |pile|
      @play_cards[pile].each do |card|
        @game.play_pile.add @player.cards[pile].remove(card)
      end
    end
  end
end
