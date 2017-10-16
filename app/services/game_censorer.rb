class GameCensorer
  def initialize(game_hash)
    @game = game_hash
  end

  def for_position(position)
    @position = position
    self
  end

  def censor
    game['players'] = censor_players
    game['draw_pile'] = turn_down_pile(game['draw_pile'])
    game['valid_plays'] = censor_plays
    game
  end

  protected

  attr_reader :game, :position

  def censor_plays
    game['valid_plays'].select { |p| p['player'] == position }
  end

  def censor_players
    game['players'].map { |player| censor_player(player) }
  end

  def censor_player(player)
    censored_player = turn_down_face_down(player)
    censored_player = turn_down_in_hand(player) if censor_for?(player)
    censored_player
  end

  def censor_for?(player)
    player['position'] != position
  end

  def turn_down_face_down(player)
    cards = player['cards']
    cards['face_down'] = turn_down_pile(cards['face_down'])
    player
  end

  def turn_down_in_hand(player)
    cards = player['cards']
    cards['in_hand'] = turn_down_pile(cards['in_hand'])
    player
  end

  def turn_down_players_pile(player, pile_name)
    cards = player['cards']
    pile = cards[pile_name]
    player['cards'][pile_name] = turn_down_pile(pile)
    player
  end

  def turn_down_pile(pile)
    pile.map { |_card| 'xx' }
  end
end
