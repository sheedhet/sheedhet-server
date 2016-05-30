# creates decks of cards
class DeckFactory
  def self.build(num = 1, card_class = Card)
    new(card_class).create_deck * num
  end

  def initialize(card_class = Card)
    @card_class = card_class
  end

  def create_deck
    suits = @card_class.suits
    faces = @card_class.faces
    suits.product(faces).map do |suit, face|
      @card_class.new(suit: suit, face: face)
    end
  end
end
