class Player
  include Equivalence

  attr_accessor :cards, :name, :position

  PILES = [:face_down, :face_up, :in_hand]

  def initialize(
    cards: { in_hand: Pile.new, face_up: Pile.new, face_down: Pile.new },
    name: random_name,
    position: 0
  )
    @cards     = cards
    @name      = name
    @position  = position
  end

  def as_json
    { name: @name,
      cards: @cards.as_json,
      position: @position,
    }
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
