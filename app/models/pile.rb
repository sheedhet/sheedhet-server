# class responsible for individual piles of cards
#
class Pile
  include JsonEquivalence
  extend Forwardable

  DELEGATE_ARRAY_METHODS = %i(
    all? count include? pop sample size + - each select sort rindex first last
    to_set
  )

  delegate DELEGATE_ARRAY_METHODS => :@data

  def self.from_json(json_pile, content = Card)
    new(json_pile.map { |json| content.from_json(json) })
  end

  def initialize(existing = [], content = Card)
    content_matches = existing.all? { |obj| obj.is_a? content }
    fail ArgumentError, 'Incorrect content class' unless content_matches
    @data = existing
  end

  def as_json
    @data.as_json
  end

  # def inspect
  #   "Pile:#{as_json}"
  # end

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

  def sort
    Pile.new @data.sort { |x, y| x.sort_compare y }
  end

  def by_values
    @data.map(&:value)
  end

  def contains?(other)
    other_set = other.to_set
    other_set.subset? to_set
  end

  def get(operator, value)
    return new unless [:==, :>=, :<=].include? operator
    Pile.new @data.select { |card| card.value.public_send(operator, value) }
  end

  def get_all(face)
    Pile.new @data.select { |card| card.face == face }
  end
end
