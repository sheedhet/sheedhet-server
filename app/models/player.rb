class Player
  attr_accessor :cards, :name, :position, :swap_done

  PILES = [:face_down, :face_up, :in_hand]

  def initialize(
    cards: { in_hand: [], face_up: [], face_down: [] },
    name: random_name,
    position: 0,
    swap_done: false
  )
    @cards     = cards
    @name      = name
    @position  = position
    @swap_done = swap_done
  end

  def ==(other_player)
    other_player.class == self.class && other_player.as_json == as_json
  end

  alias_method :eql?, :==

  def hash
    as_json.hash
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
    location = cards[target].index(card)
    raise ArgumentError, "Card not found at target" if location.nil?
    cards[target].slice! location
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