class Player
  include Equivalence

  attr_accessor :cards, :name, :position

  PILES = [:in_hand, :face_up, :face_down]

  def self.new_hand(existing = {})
    PILES.map { |pile| [pile, Pile.new] }.to_h.merge!(existing)
  end

  def initialize(
    cards: self.class.new_hand,
    name: random_name,
    position: 0
  )
    @cards     = cards
    @name      = name
    @position  = position
  end

  def as_json
    { name: @name,
      position: @position,
      cards: @cards.as_json,
    }
  end

  def get_starter
    cards[:in_hand].min
  end

  def get_playable(operator:, value:, from_piles: PILES.each)
    pile = from_piles.next
    result = {}
    result[pile] = cards[pile].get(operator, value)
    empties_pile = result[pile].size == cards[pile].size
    if pile.empty? || (empties_pile && result[pile].all_same?)
      result.merge! get_playable(
        from_piles: from_piles,
        operator: operator,
        value: value
      )
    end
    result
  end

  def random_name
    [ 'Ted',
      'Bill',
      'Jim',
      'Sal',
      'Ben',
      'Tim',
      'Jon',
      'Sam',
      'Ken',
      'George',
      'Jill',
      'Sally',
      'Betty',
      'Karen',
      'Jen',
      'Sara',
      'Cindy',
      'Mel',
      'Mandy',
      'Laura'
    ].sample
  end
end
