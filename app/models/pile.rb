class Pile < Array
  def add(card)
    self << card
    self
  end

  def remove(card)
    index = self.index(card)
    raise ArgumentError, "Card #{card.as_json} not found" if index.nil?
    self.slice! index
  end
end
