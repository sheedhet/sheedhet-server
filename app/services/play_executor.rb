class PlayExecutor
  class InvalidPlayError < StandardError; end

  attr_reader :game, :play

  def initialize(game:, play:)
    @game = game
    @play = play
  end

  def valid?
    game.valid_plays.any? { |valid_play| valid_play.as_json == play.as_json }
  end

  def execute!
    raise InvalidPlayError unless valid?
    send_cards_to_play_pile
    game.history.push(play)
    game.update_valid_plays!
    game
  end

  def player
    @player ||= game.players.find { |p| p.position == play.position }
  end

  def send_cards_to_play_pile
    player.remove(play.hand)
    game.play_pile = game.play_pile + play.hand.all_cards
  end

  def draw_new_cards
    while player.hand.in_hand.size < game.hand_size || !game.draw_pile.empty?

    end
  end
end
