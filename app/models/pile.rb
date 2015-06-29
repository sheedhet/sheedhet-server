class Pile < Array
  include JsonEquivalence

  def self.from_json(json_pile)
    Pile.new(json_pile.map { |card| Card.from_json(card) })
  end

  def add(card)
    self << card
    self
  end

  def remove(card)
    index = self.index(card)
    raise ArgumentError, "Card #{card.as_json} not found" if index.nil?
    self.slice! index
  end

  # def same_or_greater_than(value)
  #   get(:>=, value)
  # end
  #
  # def same_or_less_than(value)
  #   get(:<=. value)
  # end
  #
  # def equal_to(value)
  #   get(:== , value)
  # end

  def all_same?
    by_values.uniq.size == 1
  end

  def by_values
    map(&:value)
  end

  def get(operator, value)
    return new unless [:==, :>=, :<=].include? operator
    Pile.new self.select { |card| card.value.public_send(operator, value) }
  end

  def get_all(face)
    Pile.new self.select { |card| card.face == face }
  end

  # def uniq_face
  #   new self.uniq(&:face)
  # end
end
