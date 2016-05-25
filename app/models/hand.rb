# Handles a player's hand of cards and their order of importance
#
class Hand
  include JsonEquivalence
  extend Direction

  CONTAINER_NAMES = %i(in_hand face_up face_down).freeze

  DELEGATE_HASH_QUERIES = %i([] each).freeze

  attr_reader :container_names

  query DELEGATE_HASH_QUERIES => :@data

  def initialize(
    existing = {},
    container = Pile,
    container_names = CONTAINER_NAMES
  )
    @container = container
    @container_names = container_names
    empty_hand = container_names.map { |pile| [pile, container.new] }.to_h
    valid_containers = existing.select { |n, _| @container_names.include?(n) }
    @data = empty_hand.merge(valid_containers)
  end

  def self.from_json(json_hand, container = Pile)
    as_hash = JSON.parse(json_hand)
    existing = as_hash.each_with_object({}) do |(pile_name, pile), result|
      json_pile = pile.to_json
      new_pile = container.from_json(json_pile)
      result[pile_name.to_sym] = new_pile
    end
    new(existing, container, as_hash.keys)
  end

  def self.random
    new(in_hand: Pile.random, face_up: Pile.random, face_down: Pile.random)
  end

  def as_json
    @data.map { |name, pile| [name, pile.as_json] }.to_h
  end

  def +(other)
    raise ArgumentError unless other.is_a?(Hand)
    combined = @container_names.each_with_object({}) do |pile_name, result|
      result[pile_name] = @data[pile_name] + other[pile_name]
    end
    Hand.new(combined, @container)
  end

  def lowest_card
    self[:in_hand].min
  end

  def add_to(target:, subject:)
    @data[target].add(subject)
    self
  end

  def remove_from(target:, subject:)
    @data[target].remove(subject)
    self
  end

  def plays
    initial_plays = plays_from_active_pile
    if initial_plays.size == 1
      face, initial_play = initial_plays.first
      extension_plays = find_extension_plays(face)
      final_plays = initial_play + extension_plays
    else
      final_plays = initial_plays.values
    end
    Array(final_plays)
  end

  protected

  def plays_from_active_pile
    pile_name, active_pile = compact.first
    return {} if active_pile.nil?
    grouped_by_face = active_pile.group_by_face
    grouped_by_face.map do |face, cards|
      [face, Hand.new(pile_name => cards)]
    end.to_h
  end

  def find_extension_plays(face)
    piles_with_cards = compact
    _active_pile = piles_with_cards.shift
    piles_with_cards.reduce(Hand.new) do |memo, (pile_name, pile)|
      grouped_by_face = pile.group_by_face
      valid = grouped_by_face[face]
      valid_hand = Hand.new(pile_name => grouped_by_face[face])
      result = memo + valid_hand unless valid.nil?
      break result if grouped_by_face.size > 1
      result
    end
  end

  def compact
    @data.reject { |_pile_name, pile| pile.empty? }
  end

  def take_deal(card, hand_size)
    container_names.reverse_each do |container_name|
      if @data[container_name].size < hand_size
        @data[container_name].add(card)
        break
      end
    end
  end
end
