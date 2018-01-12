# representation of a card in game
#
class Card
  include JsonEquivalence

  SUITS = %i(c d h s).freeze
  FACES = %i(a 2 3 4 5 6 7 8 9 10 j q k).freeze
  VALUES = {
    j: 11,
    q: 12,
    k: 13,
    a: 14,
    :'2' => 15,
    :'3' => 15,
    :'10' => 15
  }.freeze

  attr_reader :suit, :face

  def self.suits
    SUITS
  end

  def self.faces
    FACES
  end

  def self.random_card
    new(face: faces.sample, suit: suits.sample)
  end

  def self.from_json(json_string)
    suit = json_string.slice!(-1)
    new(suit: suit, face: json_string)
  end

  def initialize(suit: Card.suits.sample, face: Card.faces.sample)
    raise ArgumentError, "Invalid suit: #{suit}" unless SUITS.include?(suit)
    raise ArgumentError, "Invalid face: #{face}" unless FACES.include?(face)
    @suit = suit.to_sym
    @face = face.to_sym
  end

  def <=>(other)
    is_card = other.class == Card
    raise ArgumentError, "Can't compare Card to non-Card" unless is_card
    self_as_values = [value, face, suit]
    other_as_values = [other.value, other.face, other.suit]
    self_as_values <=> other_as_values
  end

  def value
    VALUES[face] || face.to_s.to_i
  end

  def as_json
    "#{@face}#{@suit}"
  end
end
