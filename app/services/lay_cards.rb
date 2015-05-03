class LayCards < Turn
  ACTION = 'lay_cards'
  VALID_FACES = ['a', '4', '5', '6', '9', 'j', 'q', 'k']

  def execute
    Player::PILES.each do |pile|
      @play_cards[pile].each do |card|
        @game.play_pile.add @player.cards[pile].remove(card)
      end
    end
  end
end
