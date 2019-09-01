# class representing a player with cards and a position
#
class Player
  include JsonEquivalence

  PLAYER_NAMES = %w(
    Ted
    Bill
    Jim
    Sal
    Ben
    Kelly
    Tim
    Jon
    Sam
    Ken
    George
    Jill
    Sally
    Betty
    Karen
    Jen
    Sara
    Cindy
    Mel
    Mandy
    Laura
    Phil
    Max
    Nick
    Carly
    Amanda
    Emma
    Liz
    Kyle
    Cody
    Evan
    Nolan
    Tony
    Rae
  ).freeze

  attr_accessor :cards, :name, :position

  def self.from_json(json, container: Hand)
    hash = JSON.parse(json)
    cards = container.from_json(hash['cards'].to_json)
    new(name: hash['name'], position: hash['position'], existing: cards)
  end

  def initialize(
    name: random_name,
    position: 0,
    container: Hand,
    existing: nil
  )
    @cards = existing || container.new
    @container = container
    @name = name
    @position = position
  end

  def as_json
    {
      name: @name,
      position: @position,
      cards: @cards.as_json
    }.as_json
  end

  def take_deal(card, hand_size)
    cards.take_deal(card, hand_size)
  end

  def plays
    plays_per_pile = cards.play_hands_per_pile.map do |hand|
      Play.new(position: position, hand: hand, destination: :play_pile)
    end
    in_hand_onlys = plays_per_pile.select(&:in_hand_only?)
    if (in_hand_onlys.size == 1)
      combinable = plays_per_pile.find do |play|
        play.face_up_only? && play.face == in_hand_onlys.first.face
      end
      plays_per_pile = [combinable + in_hand_onlys.first] if combinable
    end
    if (!in_hand_onlys.empty?)
      plays_per_pile = plays_per_pile.reject { |play| play.face_up_only? }
    end
    plays_per_pile
  end

  def add_to(target:, subject:)
    cards.add_to(target: target, subject: subject)
    self
  end

  def remove(hand)
    cards.remove(hand)
    self
  end

  def get_playable(operator:, value:)
    cards.get_playable(operator: operator, value: value)
  end

  def lowest_card
    cards.lowest_card
  end

  def has_cards?
    !cards.empty?
  end

  def only_face_down_cards?
    cards.face_down_only?
  end

  def random_name
    PLAYER_NAMES.sample
  end
end
