# representation of a card in game
#
class Card
  include JsonEquivalence

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

  attr_reader :suit, :face

  def self.random_card
    new(face: FACES.sample, suit: SUITS.sample)
  end

  def self.from_json(json_string)
    suit = json_string.slice!(-1)
    new(suit: suit, face: json_string)
  end


  def initialize(suit: SUITS.sample, face: FACES.sample)
    fail ArgumentError, "Invalid suit: #{suit}" unless SUITS.include?(suit)
    fail ArgumentError, "Invalid face: #{face}" unless FACES.include?(face)
    @suit = suit
    @face = face
  end

  def <=>(other)
    is_card = other.class == Card
    fail ArgumentError, "Can't compare Card to non-Card" unless is_card
    self_as_values = [value, face, suit]
    other_as_values = [other.value, other.face, other.suit]
    self_as_values <=> other_as_values
  end

  def value
    VALUES[face] || face.to_i
  end

  def as_json
    "#{@face}#{@suit}"
  end
end
