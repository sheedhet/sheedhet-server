class Pile < Array
  def add(card)
    @cards << card
    self
  end

  def remove(card)
    index = @cards.index(card)
    raise ArgumentError, "Card #{card.as_json} not found" if index.nil?
    @cards.slice! index
  end
end
