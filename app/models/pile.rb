require 'json'

# class responsible for individual piles of cards
#
class Pile
  include JsonEquivalence
  extend Direction

  DELEGATE_ARRAY_COMMANDS = %i( each select )

  DELGATE_ARRAY_QUERIES = %i(
    all? count include? pop size + - sort rindex first last to_set sample
  )

  command DELEGATE_ARRAY_COMMANDS => :@data
  query DELGATE_ARRAY_QUERIES => :@data

  def self.from_json(json_pile, content = Card)
    as_array = JSON.parse(json_pile)
    array_as_json = as_array.map do |json|
      content.from_json(json)
    end
    new(array_as_json)
  end

  def initialize(existing = [], content = Card)
    content_matches = existing.all? { |obj| obj.is_a?(content) }
    fail ArgumentError, 'Incorrect content class' unless content_matches
    @data = existing
  end

  def as_json
    @data.map(&:as_json)
  end

  def add(card)
    @data << card
    self
  end

  def remove(card)
    index = @data.index(card)
    fail ArgumentError, "Card #{card} not found" if index.nil?
    @data.slice!(index)
  end

  # SMELLY
  def all_same?
    by_values.uniq.size == 1
  end

  def sort
    @data = data.sort { |x, y| x <=> y }
    self
  end

  # SMELLY
  def by_values
    @data.map(&:value)
  end

  # SMELLY
  def contains?(other)
    other_set = other.to_set
    other_set.subset?(to_set)
  end

  def get(operator, value)
    return new unless [:==, :>=, :<=].include?(operator)
    select { |card| card.value.public_send(operator, value) }
  end

  def get_all(face)
    select { |card| card.face == face }
  end
end
