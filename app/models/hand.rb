# Handles a player's hand of cards and their order of importance
#
class Hand
  include JsonEquivalence
  extend Direction

  CONTAINER_NAMES = %i(in_hand face_up face_down).freeze

  DELEGATE_HASH_COMMANDS = %i(merge!).freeze
  DELEGATE_HASH_QUERIES = %i([] each).freeze

  attr_reader :container_names

  command DELEGATE_HASH_COMMANDS => :@data
  query DELEGATE_HASH_QUERIES => :@data

  def initialize(
    existing = {},
    container = Pile,
    container_names = CONTAINER_NAMES
  )
    @container = container
    @container_names = container_names
    empty_hand = container_names.map { |pile| [pile, container.new] }.to_h
    @data = empty_hand.merge(existing)
  end

  def as_json
    @data.map { |name, pile| [name, pile.as_json] }.to_h
  end

  def get_playable(operator:, value:)
    new_hand = Hand.new(
      container: @container,
      container_names: @container_names
    )
    all_by_operator = @data.each_with_object(new_hand) do |(name, pile), result|
      result.merge!("#{name}": pile.get(operator, value))
    end
    all_by_operator.trim_unplayable
  end

  def trim_unplayable
    new_hand = Hand.new(
      container: @container,
      container_names: @container_names
    )
    @data.each_with_object(new_hand) do |(pile_name, pile), result|
      result[pile_name] = pile
      break unless pile.all_same?
    end
  end

  def lowest_card
    self[:in_hand].min
  end

  def add_to(target:, subject:)
    @data[target].add(subject)
  end

  def remove_from(target:, subject:)
    @data[target].remove(subject)
  end
end
