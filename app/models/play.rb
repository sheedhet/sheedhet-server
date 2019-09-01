class Play
  include JsonEquivalence

  attr_reader :position, :hand, :destination

  def self.from_json(json, container: Hand)
    hash = JSON.parse(json)
    position = hash['position'].to_i
    hand = container.from_json(hash['hand'].to_json)
    destination = hash['destination'] || :play_pile
    new(position: position, hand: hand, destination: destination)
  end

  def initialize(position:, hand:, destination: :play_pile, container: Hand)
    @position = position
    @hand = hand || container.new
    @destination = destination.to_sym
  end

  def as_json
    {
      position: position,
      hand: hand.as_json,
      destination: destination
    }.as_json
  end

  def ==(other)
    raise ArgumentError, "Can't compare Play with #{other.class}" unless other.is_a?(Play)
    as_json == other.as_json
  end

  def +(other)
    raise ArgumentError, "Can't add Play to #{other.class}" unless other.is_a?(Play)
    raise ArgumentError, "Can't add Play with different destination" unless other.destination == destination
    raise ArgumentError, "Can't add Play for different position" unless other.position == position
    combined_hand = hand + other.hand
    self.class.new(position: position, destination: destination, hand: combined_hand)
  end

  def value
    first_card.value
  end

  def face
    first_card.face
  end

  def non_empty_piles
    hand.compact
  end

  def first_card
    (_pile_name, cards) = non_empty_piles.first
    cards.first
  end

  def in_hand_only?
    hand.in_hand_only?
  end

  def face_up_only?
    hand.face_up_only?
  end

  def face_down_only?
    hand.face_down_only?
  end

  def flip_play?
    destination.to_s.start_with?('flip')
  end

  def swap_play?
    destination == :swap
  end

  def pick_up_play?
    destination == :in_hand
  end

  def contains?(other)
    raise ArgumentError unless other.is_a?(Play)
    same_destination = other.destination == destination
    same_position = other.position == position
    same_destination && same_position && hand.contains?(other.hand)
  end
end
