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

  def initialize(
    name: random_name,
    position: 0,
    container: Hand,
    existing: {}
  )
    @cards = container.new(existing)
    @name = name
    @position = position
  end

  def as_json
    { name: @name,
      position: @position,
      cards: @cards.as_json
    }
  end

  # perhaps a :deal flag so we can do different rules during deal?
  # would it be crazy to use << ?
  # def take card ?? better name or send card?
  # def add_to_top_pile(card) {
  #   this might simplify interaction with hand/pile objects
  # }

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
