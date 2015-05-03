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

  # def remove_from_hand(card)
  #   remove_from(card: card, target: :in_hand)
  # end

  # def remove_from_face_up(card)
  #   remove_from(card: card, target: :face_up)
  # end

  # def remove_from_face_down(card)
  #   remove_from(card: card, target: :face_down)
  # end

  # def add_to_hand(card)
  #   add_to(card: card, target: :in_hand)
  # end

  # def add_to_face_up(card)
  #   add_to(card: card, target: :face_up)
  # end

  # def remove_from(card:, target:)
  #   cards[target].remove card
  # end

  # def add_to(card:, target:)
  #   cards[target] << card
  # end

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
