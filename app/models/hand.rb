class Hand < Hash
  include JsonEquivalence

  PILES = [:in_hand, :face_up, :face_down]
  # DEFAULT = PILES.map{ |pile| [pile, Pile.new] }.to_h
  DEFAULT = {
    in_hand: Pile.new,
    face_up: Pile.new,
    face_down: Pile.new
  }

  # seems like we need a Hand class for handling groups of piles and their
  # order of operations, get on it.
  def initialize(existing = {})
    # require 'pry'
    # binding.pry
    thing = Hand::DEFAULT.merge existing
    puts "returning: #{thing}"
    thing
  end

  def get_playable(operator:, value:, from_piles: keys.each)
    # require 'pry'
    # binding.pry
    pile = from_piles.next
    result = Hand.new
    result[pile] = self[pile].get(operator, value)
    empties_pile = result[pile].size == self[pile].size
    if pile.empty? || (empties_pile && result[pile].all_same?)
      Hand.new(result.merge get_playable(
        from_piles: from_piles,
        operator: operator,
        value: value
      ))
    end
    Hand.new result
  end

end
