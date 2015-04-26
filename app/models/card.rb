class Card
  include Equivalence

  attr_reader :suit, :face

  SUITS = ['c', 'd', 'h', 's']
  FACES = ['a', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'j', 'q', 'k' ]

  def self.random_card
    new(face: FACES.sample, suit: SUITS.sample)
  end

  def initialize(suit: 's', face: 'a')
    @suit = suit
    @face = face
  end

  def <=>(other_card)
    self.as_json <=> other_card.as_json
  end

  def as_json
    "#{@face}#{@suit}"
  end
end
