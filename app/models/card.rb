class Card
  include Equivalence

  attr_reader :suit, :face

  SUITS = ['c', 'd', 'h', 's']
  FACES = ['a', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'j', 'q', 'k' ]
  VALUES = {
    'j' => 11,
    'q' => 12,
    'k' => 13,
    'a' => 14,
    '2' => 15,
    '3' => 15,
    '10' => 15
   }

  def self.random_card
    new(face: FACES.sample, suit: SUITS.sample)
  end

  def initialize(suit: 's', face: 'a')
    @suit = suit
    @face = face
  end

  def <=>(other_card)
    is_card = other_card.class == Card
    raise ArgumentError, "Can't compare Card to non-Card" unless is_card
    [value, face, suit] <=> [other_card.value, other_card.face, other_card.suit]
  end

  def value
    VALUES[face] || face.to_i
  end

  def as_json
    "#{@face}#{@suit}"
  end
end
