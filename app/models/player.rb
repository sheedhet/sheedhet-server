# class representing a player with cards and a position
#
class Player
  include JsonEquivalence

  PLAYER_NAMES = %w(
    Ted
    Bill
    Jim
    Sal
    Ben
    Tim
    Jon
    Sam
    Ken
    George
    Jill
    Sally
    Betty
    Karen
    Jen
    Sara
    Cindy
    Mel
    Mandy
    Laura
    Phil
    Max
    Nick
    Carly
    Amanda
    Emma
    Cody
    Evan
    Nolan
    Tony
    Rae
  ).freeze

  attr_accessor :cards, :name, :position

  def self.from_json(json, container: Hand)
    hash = JSON.parse(json)
    cards = container.from_json(hash['cards'].to_json)
    new(name: hash['name'], position: hash['position'], existing: cards)
  end

  def initialize(
    name: random_name,
    position: 0,
    container: Hand,
    existing: Hand.new
  )
    @cards = existing
    @container = container
    @name = name
    @position = position
  end

  def dup
    self.class.new(name: name.dup, position: position, existing: cards.dup)
  end

  def as_json
    { name: @name,
      position: @position,
      cards: @cards.as_json }
  end

  def take_deal(card, hand_size)
    cards.take_deal(card, hand_size)
  end

  def plays
    cards.plays.map { |hand| Play.new(player: self, hand: hand) }
  end

  def add_to(target:, subject:)
    cards.add_to(target: target, subject: subject)
    self
  end

  def get_playable(operator:, value:)
    cards.get_playable(operator: operator, value: value)
  end

  def lowest_card
    cards.lowest_card
  end

  def random_name
    PLAYER_NAMES.sample
  end
end
