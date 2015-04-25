class LayStandardCard < Turn
  ACTION = 'lay_standard_card'
  VALID_FACES = ['a', '4', '5', '6', '9', 'j', 'q', 'k']

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
