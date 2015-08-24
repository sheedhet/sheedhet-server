# Handles a player's hand of cards and their order of importance
#
class Hand < Hash
  include JsonEquivalence

  PILE_NAMES = %i(in_hand face_up face_down)

  # def self.from_json(json_hand)
  # json_hand.each do ||
  # end
  # end

  def initialize(existing = {}, storage_type = Pile, pile_names = PILE_NAMES)
    empty_hand = pile_names.map { |pile| [pile, storage_type.new] }.to_h
    merge! empty_hand.merge existing
  end

  def get_playable(operator:, value:)
    all_by_operator = each_with_object(Hand.new) do |(name, pile), playable|
      playable.merge! "#{name}": pile.get(operator, value)
    end
    all_by_operator.trim_unplayable
  end

  def trim_unplayable
    each_with_object(Hand.new) do |(pile_name, pile), trimmed|
      trimmed.merge!(pile_name => pile)
      break unless pile.all_same?
    end
  end

  def lowest_card
    self[:in_hand].min
  end

  def flatten
    reject! { |_, pile| pile.empty? }
  end
end
