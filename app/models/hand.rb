# Handles a player's hand of cards and their order of importance
#
class Hand < Hash
  include JsonEquivalence

  PILES = [:in_hand, :face_up, :face_down]

  # def self.from_json(json_hand)
  # json_hand.each do ||
  # end
  # end

  def initialize(existing = {}, storage_type = Pile, pile_names = PILES)
    empty_hand = pile_names.map { |pile| [pile, storage_type.new] }.to_h
    merge!(empty_hand.merge existing)
  end

  def get_playable(operator:, value:)
    all_by_operator = inject(Hand.new) do |playable, (name, next_pile)|
      playable.merge "#{name}": next_pile.get(operator, value)
    end
    all_by_operator.trim_unplayable
  end

  def trim_unplayable
    inject(Hand.new) do |trimmed, (pile_name, pile)|
      trimmed.merge!(pile_name => pile)
      break trimmed unless pile.all_same?
    end
  end

  def flatten
    delete_if { |_, pile| pile.empty? }
  end
end
