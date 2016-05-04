# Service responsible for creating games
#
class GameFactory
  DEFAULT_CLASSES = {
    player_class: Player,
    game_class: Game,
    # card_class: Card,
    dealer_class: CardDealer
  }.freeze

  DEFAULT_OPTIONS = {
    hand_size: 4,
    num_decks: 1,
    num_players: 3
  }.freeze

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
  end

  def define_classes(param_classes)
    all_classes = DEFAULT_CLASSES.merge param_classes
    @player_class = all_classes[:player_class]
    @game_class = all_classes[:game_class]
    @dealer = all_classes[:dealer_class]
  end

  def reconstitute_from_state
    raise "You haven't written reconstitute_from_state yet"
  end

  def create_new_game
    deck = create_cards
    game = @game_class.new(deck, @hand_size)
    players = create_players
    players.each { |p| game.add_player(p) }
    @dealer.deal(game)
    game
  end

  def create_cards(deck_factory = DeckFactory)
    deck_factory.build(@num_decks)
  end

  private

  def create_players(existing_players: [])
    Array.new(@num_players) do |i|
      new_player_details = existing_players.fetch(i, position: i)
      @player_class.new(new_player_details)
    end
  end
end
