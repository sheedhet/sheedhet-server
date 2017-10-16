# represents a possible game turn
class Play
  include JsonEquivalence

  attr_reader :player, :hand

  def initialize(player:, hand:)
    @player = player
    @hand = hand
  end

  def as_json
    {
      position: player.position,
      hand: hand.as_json
    }
  end

  def value
    first_card.value
  end

  def face
    first_card.face
  end

  def non_empty_piles
    hand.compact
  end

  def first_card
    _pile_name, cards = non_empty_piles.first
    cards.first
  end
end
