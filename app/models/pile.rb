# class responsible for individual piles of cards
#
class Pile
  include JsonEquivalence
  # attr_reader :data

  def self.from_json(json_pile, content = Card)
    new(json_pile.map { |json| content.from_json(json) })
  end

  def initialize(existing = [], content = Card)
    @data = Array.new existing.map { |object| content.from_json object }
  end

  def as_json
    @data.as_json
  end

  def inspect
    "Pile:#{as_json}"
  end

  def add(card)
    @data << card
    @data
  end

  def remove(card)
    index = @data.index(card)
    fail ArgumentError, "Card #{card.as_json} not found" if index.nil?
    @data.slice! index
  end

  def all_same?
    by_values.uniq.size == 1
  end

  def by_values
    @data.map(&:value)
  end

  def get(operator, value)
    return new unless [:==, :>=, :<=].include? operator
    Pile.new @data.select { |card| card.value.public_send(operator, value) }
  end

  def get_all(face)
    Pile.new @data.select { |card| card.face == face }
  end
end
