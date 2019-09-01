# Deals cards in a game
#
class CardDealer
  def self.deal(game, hand_klass = Hand)
    new(game, hand_klass).deal_new_game
  end

  def initialize(game, hand_klass = Hand)
    @cards = game.draw_pile
    @hand_size = game.hand_size
    @players = game.players
    @hand_klass = hand_klass
  end

  def deal_new_game
    @cards.shuffle!
    @hand_klass::CONTAINER_NAMES.each { |target| deal_everyone(target) }
  end

  def deal_everyone(target)
    @hand_size.times do
      @players.each do |player|
        player.add_to(target: target, subject: @cards.pop)
      end
    end
  end
end
