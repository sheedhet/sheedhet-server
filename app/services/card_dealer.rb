# Deals cards in a game
#
class CardDealer
  def self.deal(game, hand_type = Hand)
    new(game, hand_type).deal_new_game
  end

  def initialize(game, hand_type = Hand)
    @cards = game.draw_pile
    @hand_size = game.hand_size
    @players = game.players
    @hand_type = hand_type
  end

  def deal_new_game
    @cards.shuffle!
    @hand_type::CONTAINER_NAMES.each { |target| deal_everyone(target) }
  end

  def deal_everyone(target)
    @hand_size.times do
      @players.each do |player|
        player.add_to(target: target, subject: @cards.pop)
      end
    end
  end
end
