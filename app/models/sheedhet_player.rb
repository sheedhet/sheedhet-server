class SheedhetPlayer
  attr_accessor :cards, :name, :position, :swap_done

  def initialize(
    cards: { in_hand: [], face_up: [], face_down: [] },
    name: nil,
    position: nil,
    swap_done: false
  )
    @cards     = cards
    @name      = name || random_name
    @position  = position || (raise ArgumentError, "Player needs position")
    @swap_done = swap_done
  end

  def as_json
    { name: @name,
      cards: @cards.as_json,
      position: @position,
      swap_done: @swap_done
    }
  end

  def remove_from_hand(card)
    remove_from(card: card, target: :in_hand)
  end

  def remove_from_face_up(card)
    remove_from(card: card, target: :face_up)
  end

  def remove_from_face_down(card)
    remove_from(card: card, target: :face_down)
  end

  def add_to_hand(card)
    add_to(card: card, target: :in_hand)
  end

  def add_to_face_up(card)
    add_to(card: card, target: :face_up)
  end

  def remove_from(card:, target:)
    cards[target].slice! cards[target].index(card)
  end

  def add_to(card:, target:)
    cards[target] << card
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
