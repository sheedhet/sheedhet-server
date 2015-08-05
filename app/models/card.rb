# representation of a card in game
#
class Card
  include JsonEquivalence

  attr_reader :suit, :face

  SUITS = %w(c d h s)
  FACES = %w(a 2 3 4 5 6 7 8 9 10 j q k)
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

  def self.from_json(json_string)
    suit = json_string.slice!(-1)
    new(suit: suit, face: json_string)
  end

  def initialize(suit: SUITS.sample, face: FACES.sample)
    @suit = suit
    @face = face
  end

  def <=>(other)
    is_card = other.class == Card
    fail ArgumentError, "Can't compare Card to non-Card" unless is_card
    [value, face, suit] <=> [other.value, other.face, other.suit]
  end

  def inspect
    "Card:#{as_json}"
  end

  def value
    VALUES[face] || face.to_i
  end

  def as_json
    "#{@face}#{@suit}"
  end
end
