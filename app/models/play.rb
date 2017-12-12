# represents a possible game turn
class Play
  include JsonEquivalence

  attr_reader :position, :hand

  def self.from_json(json, container: Hand)
    hash = JSON.parse(json)
    position = hash['position']
    hand = container.from_json(hash['hand'].to_json)
    new(position: position, hand: hand)
  end

  def initialize(position:, hand:)
    @position = position
    @hand = hand
  end

  def as_json
    {
      position: position,
      hand: hand.as_json
    }.as_json
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
    (_pile_name, cards) = non_empty_piles.first
    cards.first
  end

  def just_cards
    just_cards # haha what
  end
end
