# Service responsible for creating games
#
class GameFactory
  DEFAULT_CLASSES = {
    player_class: Player,
    game_class: Game,
    # card_class: Card,
    # dealer_class: CardDealer
  }

  DEFAULT_OPTIONS = {
    hand_size: 4,
    num_decks: 1,
    num_players: 3
  }

  def self.build(state: {})
    factory = new(state: state)
    state.empty? ? factory.create_new_game : factory.reconstitute_from_state
  end

  def initialize(
    state: {},
    classes: DEFAULT_CLASSES,
    options: DEFAULT_OPTIONS
  )
    @hand_size = options[:hand_size]
    @num_decks = options[:num_decks]
    @num_players = options[:num_players]
    @state = state
    define_classes(classes)
    @game = @game_class.new
  end

  def define_classes(param_classes)
    all_classes = DEFAULT_CLASSES.merge param_classes
    @player_class = all_classes[:player_class]
    @game_class = all_classes[:game_class]
  end

  def reconstitute_from_state
    fail "You haven't written reconstitute_from_state yet"
  end

  def create_new_game
    @players = create_players
    # @game_cards = create_game_cards
    # deal_new_game
    @game_class.new.tap do |game|
      # game.draw_pile = @game_cards
      game.hand_size = @hand_size
      game.players = @players
    end
  end

  def deck=(deck)
    @draw_pile = deck
  end

  private

  def create_players(existing_players: [])
    @num_players.times do |i|
      new_player_details = existing_players.fetch(i, position: i)
      new_player = @player_class.new(new_player_details)
      @game.add_player(new_player)
    end
  end
end
