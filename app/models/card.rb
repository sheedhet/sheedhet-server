class Card
  attr_reader :suit, :face

  SUITS = ['c', 'd', 'h', 's']
  FACES = ['a', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'j', 'q', 'k' ]
  def initialize(suit: 's', face: 'a')
    @suit = suit
    @face = face
  end

  def as_json
    "#{@face}#{@suit}"
  end
end
