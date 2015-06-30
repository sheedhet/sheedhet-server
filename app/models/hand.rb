# Handles a player's hand of cards and their order of importance
#
class Hand < Hash
  include JsonEquivalence

  PILES = [:in_hand, :face_up, :face_down]

  def initialize(existing = {}, storage_type = Pile, pile_names = PILES)
    empty_hand = pile_names.map { |pile| [pile, storage_type.new] }.to_h
    merge!(empty_hand.merge existing)
  end

  def get_playable(operator:, value:, from_piles: keys.each)
    pile = from_piles.next
    result = Hand.new
    result[pile] = self[pile].get(operator, value)
    empties_pile = result[pile].size == self[pile].size
    if pile.empty? || (empties_pile && result[pile].all_same?)
      result.merge! get_playable(
        from_piles: from_piles,
        operator: operator,
        value: value)
    end
  end

  def flatten
    delete_if { |_, pile| pile.empty? }
  end
end
