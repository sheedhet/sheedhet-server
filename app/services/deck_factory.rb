# creates decks of cards
class DeckFactory
  def self.build(num = 1)
    new.create_deck * num
  end

  def initialize(card_class: Card)
    @card_class = card_class
  end

  def create_deck
    suits = @card_class::SUITS
    faces = @card_class::FACES
    suits.product(faces).map do |suit, face|
      @card_class.new(suit: suit, face: face)
    end
  end
end
