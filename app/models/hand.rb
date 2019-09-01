# Handles a player's hand of cards and their order of importance
#
class Hand
  include JsonEquivalence
  extend Direction

  CONTAINER_NAMES = %i(in_hand face_up face_down).freeze

  DELEGATE_HASH_QUERIES = %i([] each to_h).freeze

  attr_reader :container

  query DELEGATE_HASH_QUERIES => :data

  def self.from_json(json_hand, container = Pile)
    as_hash = JSON.parse(json_hand)
    existing = as_hash.each_with_object({}) do |(pile_name, pile), result|
      json_pile = pile.as_json.to_json
      new_pile = container.from_json(json_pile)
      result[pile_name.to_sym] = new_pile
    end
    new(existing, container)
  end

  def self.random(container = Pile)
    random_hand_hash = CONTAINER_NAMES.each_with_object({}) do |name, result|
      result[name] = container.random
    end
    new(random_hand_hash)
  end

  def initialize(
    existing = {},
    container = Pile
  )
    @container = container
    empty_hand = CONTAINER_NAMES.map { |pile| [pile, container.new] }.to_h
    valid_containers = existing.select { |n, _| CONTAINER_NAMES.include?(n) }
    @data = empty_hand.merge(valid_containers)
  end

  def as_json
    data.each_with_object({}) do |(name, pile), result_hash|
      result_hash[name] = pile.as_json
    end
  end

  def +(other)
    raise ArgumentError, "Can't add to #{other.class}" unless other.is_a?(Hand)
    combined = CONTAINER_NAMES.each_with_object({}) do |pile_name, result|
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
    CONTAINER_NAMES.all? { |name| data[name].contains?(other[name]) }
  end

  def face_down_only?
    compact.keys == [:face_down]
  end

  def face_up_only?
    compact.keys == [:face_up]
  end

  def in_hand_only?
    compact.keys == [:in_hand]
  end

  def empty?
    compact.empty?
  end

  # protected

  attr_accessor :data

  def play_hands_per_pile
    data.each_with_object([]) do |(pile_name, pile), grouped_by_face|
      pile_play_hands = pile.group_by_face.map do |_face, cards|
        self.class.new({pile_name => container.new(cards)})
      end
      grouped_by_face.concat(pile_play_hands) unless pile_name == :face_down
    end
  end

  def plays_from_active_pile
    pile_name, active_pile = compact.first
    return {} if active_pile.nil?
    grouped_by_face = active_pile.group_by_face
    active_pile_plays = grouped_by_face.map do |face, cards|
      [face, self.class.new(pile_name => container.new(cards))]
    end.to_h

    if active_pile_plays.size == 1 && initial_pile_name == :in_hand && !compact[:face_up].nil?
      _face_up, face_up_pile = compact[:face_up]
      extension_plays = face_up_pile.group_by_face[face] unless face_up_pile.nil?
      unless extension_plays.nil?
        extension_hand = self.class.new(face_up: extension_plays)
        active_pile_plays[face] = active_pile_plays[face] + extension_hand
      end
    end
    active_pile_plays
  end

  def find_extension_plays(face)
    piles_with_cards = compact
    active_pile_name, _active_pile = piles_with_cards.shift
    piles_with_cards.delete(pile_name)
    empty_hand = self.class.new
    piles_with_cards.reduce(empty_hand) do |extension_plays, (pile_name, pile)|
      grouped_by_face = pile.group_by_face
      valid = grouped_by_face[face]
      valid_hand = self.class.new(pile_name => grouped_by_face[face])
      result = extension_plays + valid_hand unless valid.nil?
      break result if grouped_by_face.size > 1
      result
    end
  end

  def take_deal(card, hand_size)
    CONTAINER_NAMES.reverse_each do |container_name|
      if data[container_name].size < hand_size
        data[container_name].add(card)
        break
      end
    end
  end
end
