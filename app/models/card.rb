class Card
  attr_reader :suit, :face

  SUITS = ['c', 'd', 'h', 's']
  FACES = ['a', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'j', 'q', 'k' ]

  def self.random_card
    FACES.sample + SUITS.sample
  end

  def initialize(suit: 's', face: 'a')
    @suit = suit
    @face = face
  end

  def ==(other_card)
    other_card.class == self.class && other_card.as_json == as_json
  end

  alias_method :eql?, :==

  def hash
    as_json.hash
  end

  def as_json
    "#{@face}#{@suit}"
  end
end
