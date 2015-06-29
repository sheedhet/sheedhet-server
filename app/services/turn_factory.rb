class TurnFactory
  attr_reader :player

  def self.for(player)
    new(player)
  end

  def initialize(player)
    @player = player
  end

  def greater_than(value)
    @value = value
    @operator = :>=
    make_turns
  end

  def less_than(value)
    @value = value
    @operator = :<=
    make_turns
  end

  def equal_to(value)
    @value = value
    @operator = :==
    make_turns
  end

  def eligible_cards
    @eligible_cards ||= player.get_playable(operator: @operator, value: @value)
  end

  def make_turns
    gathered = gather_by_face
    Turn.build(
      action: :lay_cards,
      game: :nil,
      play_cards: cards,
      position: player.position
    )
  end

  def gather_by_face(from_piles = eligible_cards.each)
    pile = from_piles.next
    return if pile.nil?
    result = {}
    grouped_by_face = eligible_cards[pile].group_by(&:face)
    plays = grouped_by_face.values
    result[pile] = plays
    result.merge! gather_by_face(from_piles) if plays.size == 1
    result
  end
end
