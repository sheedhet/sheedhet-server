module GameStore
  class GameNotFound < StandardError
  end

  def self.persistence=(db_model)
    @persistence = db_model
    @persistence
  end

  def self.persistence
    @persistence || GameStore.persistence = JsonStore
  end

  # def self.model=(app_model)
  #   @model = app_model
  #   @model
  # end

  # def self.model
  #   @model || GameStore.model = Game
  # end

  def self.save(game)
    record = GameStore.persistence.new(id: game.id, json: game.to_json)
    # validation?
    record.save!
  end

  def self.find(game_id)
    record = GameStore.persistence.where(id: game_id)
    raise GameNotFound if record.empty?
    record.first
  end

  def self.load(game_id)
    game_record = find(game_id)
    GameFactory.from_json(game_record.json)
  end

  def self.all
    GameStore.persistence.all
  end
end
