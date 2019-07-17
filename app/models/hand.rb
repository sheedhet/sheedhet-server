# Handles a player's hand of cards and their order of importance
#
class Hand
  include JsonEquivalence
  extend Direction

  CONTAINER_NAMES = %i(in_hand face_up face_down).freeze

  DELEGATE_HASH_QUERIES = %i([] each to_h).freeze

  attr_reader :container_names, :container

  query DELEGATE_HASH_QUERIES => :data

  def self.from_json(json_hand, container = Pile)
    as_hash = JSON.parse(json_hand)
    existing = as_hash.each_with_object({}) do |(pile_name, pile), result|
      json_pile = pile.as_json.to_json
      new_pile = container.from_json(json_pile)
      result[pile_name.to_sym] = new_pile
    end
    new(existing, container, as_hash.keys)
  end

  def self.random(container_names = CONTAINER_NAMES, container = Pile)
    new(container_names.zip(container.random).to_h)
  end

  def initialize(
    existing = {},
    container = Pile,
    container_names = CONTAINER_NAMES
  )
    @container = container
    @container_names = container_names.map(&:to_sym)
    empty_hand = @container_names.map { |pile| [pile, container.new] }.to_h
    valid_containers = existing.select { |n, _| @container_names.include?(n) }
    @data = empty_hand.merge(valid_containers)
  end

  def as_json
    data.each_with_object({}) do |(name, pile), result_hash|
      result_hash[name] = pile.as_json unless pile.empty?
    end
  end

  def +(other)
    raise ArgumentError, "Can't add to #{other.class}" unless other.is_a?(Hand)
    combined = container_names.each_with_object({}) do |pile_name, result|
      result[pile_name] = data[pile_name] + other[pile_name]
    end
    self.class.new(combined, container)
  end

  def lowest_card
    self[:in_hand].min
  end

  def add_to(target:, subject:)
    data[target].add(subject)
    self
  end

  def remove_from(target:, subject:)
    data[target].remove(subject)
    self
  end

  def -(other)
    raise ArgumentError, "Can't subtract from non-Hand" unless other.is_a?(Hand)
    difference = other.each_with_object({}) do |(pile_name, pile), hash|
      hash[pile_name] = [pile_name] - pile
    end
    new(difference)
  end

  def remove(hand)
    hand.each do |pile_name, cards|
      data[pile_name] = data[pile_name] - cards
    end
  end

  def plays
    initial_plays = plays_from_active_pile
    # if initial_plays.size == 1
    #   face, initial_play = initial_plays.first
    #   # extension_plays = find_extension_plays(face)
    #   # final_plays = initial_play + extension_plays
    #   final_plays = initial_play
    # else
      final_plays = initial_plays.values
    # end
    Array(final_plays)
  end

  def compact
    data.reject { |_pile_name, pile| pile.empty? }
  end

  def all_cards
    data.values.reduce(:+)
  end

  def contains?(other)
    raise ArgumentError unless other.is_a?(Hand)
    has_other_container_names = other.container_names.all? do |name|
      container_names.include?(name)
    end
    return false unless has_other_container_names
    other.container_names.all? { |name| data[name].contains?(other[name]) }
  end

  def face_down_only?
    compact.keys == [:face_down]
  end

  protected

  attr_accessor :data

  def plays_from_active_pile
    pile_name, active_pile = compact.first
    return {} if active_pile.nil?
    grouped_by_face = active_pile.group_by_face
    grouped_by_face.map do |face, cards|
      [face, self.class.new(pile_name => container.new(cards))]
    end.to_h
  end

  def find_extension_plays(face)
    piles_with_cards = compact
    _active_pile = piles_with_cards.shift

    piles_with_cards.reduce(self.class.new) do |extension_plays, (pile_name, pile)|
      grouped_by_face = pile.group_by_face
      valid = grouped_by_face[face]
      valid_hand = self.class.new(pile_name => grouped_by_face[face])
      result = extension_plays + valid_hand unless valid.nil?
      break result if grouped_by_face.size > 1
      result
    end
  end

  def take_deal(card, hand_size)
    container_names.reverse_each do |container_name|
      if data[container_name].size < hand_size
        data[container_name].add(card)
        break
      end
    end
  end
end
