class Play
  include JsonEquivalence

  attr_reader :position, :hand, :destination

  def self.from_json(json, container: Hand)
    hash = JSON.parse(json)
    position = hash['position']
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
    raise ArgumentError unless other.is_a?(Play)
    as_json == other.as_json
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

  def pick_up?
    hand[:draw_pile].present?
  end

  def contains?(other)
    raise ArgumentError unless other.is_a?(Play)
    hand.contains?(other.hand)
  end
end
