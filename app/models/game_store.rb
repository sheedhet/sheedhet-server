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

  def self.new(json: nil)
    GameStore.persistence.new(json: json)
  end

  def self.save(game_object, id = nil)
    record = begin
      GameStore.find(id)
    rescue GameNotFound
      GameStore.new
    end
    record.json = game_object.to_json
    record.save!
  end

  def self.find(game_id)
    records = GameStore.persistence.where(id: game_id)
    raise GameNotFound if records.empty?
    records.first
  end

  def self.load(game_id)
    game_record = GameStore.find(game_id)
    GameFactory.from_json(game_record.json)
  end

  def self.all
    GameStore.persistence.all
  end
end
