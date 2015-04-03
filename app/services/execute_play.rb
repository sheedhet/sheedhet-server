class ExecutePlay

  def self.for(game)
    new(game)
  end

  def initialize(game)
    @game = game
  end

  def with(play)
    # do inside a transaction?
    @play = play
    @player = play[:player]

    if @play[:action] == 'swap'
      execute_swap
    end

    add_play_to_history
  end

  # def initialize(game: nil, play: nil)
    # @game = game
    # @play = play
    # @player = play[:player]
  # end

  def execute
    if @play[:action] == 'swap'
      execute_swap
    end

    add_play_to_history
  end

  def add_play_to_history
    @game.history << @play
  end

  def execute_swap
    @player.cards[:in_hand] = @play[:in_hand]
    @player.cards[:face_up] = @play[:face_up]
    # from_hand = @player.remove_from_hand(@play[:in_hand])
    # from_up = @player.remove_from_face_up(@play[:face_up])
    # @player.add_to_hand(from_up)
    # @player.add_to_face_up(from_hand)
  end

end
