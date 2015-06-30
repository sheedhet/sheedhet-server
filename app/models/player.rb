class Player
  include JsonEquivalence

  attr_accessor :cards, :name, :position

  def initialize(
    cards: Hand.new,
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
      cards: @cards.as_json
    }
  end

  def get_playable(operator:, value:)
    cards.get_playable(operator: operator, value: value)
  end

  def get_starter
    cards[:in_hand].min
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
