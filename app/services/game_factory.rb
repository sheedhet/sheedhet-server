# Service responsible for creating games
#
class GameFactory
  DEFAULT_OPTIONS = {
    hand_size: 4,
    num_decks: 1,
    num_players: 3
  }.freeze

  DEFAULT_CLASSES = {
    player_class: Player,
    game_class: Game,
    card_dealer: CardDealer,
    deck_factory: DeckFactory
  }.freeze

  def self.build
    new.create_new_game
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    deck = Pile.from_json(hash['draw_pile'].to_json)
    players = hash['players'].map { |p| Player.from_json(p.to_json) }
    hand_size = hash['hand_size']
    Game.new(
      deck: deck,
      players: players,
      hand_size: hand_size
    ).tap do |game|
      game.history = hash['history'].map do |p|
        {
          play: Play.from_json(p['play'].to_json),
          state: p['state']
        }
      end
      game.valid_plays = hash['valid_plays'].map { |p| Play.from_json(p.to_json) }
      game.play_pile = Pile.from_json(hash['play_pile'].to_json)
      game.discard_pile = Pile.from_json(hash['discard_pile'].to_json)
    end
  end

  def initialize(
    options: DEFAULT_OPTIONS,
    classes: DEFAULT_CLASSES
  )
    @hand_size = options[:hand_size]
    @num_decks = options[:num_decks]
    @num_players = options[:num_players]
    define_classes(classes)
  end

  def create_new_game
    deck = create_cards
    players = create_players
    game = @game_class.new(deck: deck, players: players, hand_size: @hand_size)
    @card_dealer.deal(game)
    game.update_valid_plays!
    game
  end

  protected

  def define_classes(classes)
    class_list = DEFAULT_CLASSES.merge(classes)
    @player_class = class_list[:player_class]
    @game_class = class_list[:game_class]
    @card_dealer = class_list[:card_dealer]
    @deck_factory = class_list[:deck_factory]
  end

  def create_cards
    @deck_factory.build(@num_decks)
  end

  def create_players(existing_players: [])
    Array.new(@num_players) do |i|
      new_player_details = existing_players.fetch(i, position: i)
      @player_class.new(new_player_details)
    end
  end
end
