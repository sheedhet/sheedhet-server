# Service responsible for creating games
#
class GameFactory
  def initialize(hand_size: 4, num_decks: 1, num_players: 3, state: {})
    @state = state
    @hand_size = hand_size
    @num_decks = num_decks
    @num_players = num_players
  end

  def build
    @state.empty? ? create_new_game : reconstitute_from_state
  end

  def reconstitute_from_state
    fail "You haven't written reconstitute_from_state yet"
  end

  def create_new_game
    @players = create_players
    @game_cards = create_game_cards
    deal_new_game
    Game.new.tap do |game|
      game.draw_pile = @game_cards
      game.hand_size = @hand_size
      game.players = @players
    end
  end

  def deal_new_game
    @game_cards.shuffle!
    Hand::PILE_NAMES.each { |target| deal_everyone(target) }
  end

  def deal_everyone(target)
    @hand_size.times do
      @players.each do |player|
        # require 'pry'
        # binding.pry
        player.cards[target].add @game_cards.pop
      end
    end
  end

  def create_game_cards
    create_deck * @num_decks
  end

  def create_deck
    Card::SUITS.product(Card::FACES).map do |suit, face|
      Card.new(suit: suit, face: face)
    end
  end

  def create_players(existing_players: [])
    Array.new(@num_players) do |i|
      player_to_add = existing_players.fetch i, position: i
      Player.new(player_to_add)
    end
  end
end
