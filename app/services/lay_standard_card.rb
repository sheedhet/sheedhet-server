class LayStandardCard < Turn
  VALID_FACES = ['a', '4', '5', '6', '9', 'j', 'q', 'k']

  def initialize(action: 'regular', game:, position:, card:, source:)
    super(action: action, game: game, position: position)
    @card = card
    @source = source
  end

  def as_json
    super.merge {
      { card: @card,
        source: @source
      }
    }
  end

  def valid?
    @game.valid_plays.include? self
  end

  def execute

  end
end
