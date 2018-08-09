require "zlib"

module GameStore
  class GameNotFound < StandardError
  end

  def GameStore.persistence=(db_model)
    @persistence = db_model
    @persistence
  end

  def GameStore.persistence
    @persistence || GameStore.persistence = Redis.new
  end

  # def GameStore.model=(app_model)
  #   @model = app_model
  #   @model
  # end

  # def GameStore.model
  #   @model || GameStore.model = Game
  # end

  # def GameStore.new(json: nil)
  #   GameStore.persistence.new(json: json)
  # end

  def GameStore.new_id
    begin
      new_id = SecureRandom.hex(2)
    end while GameStore.persistence.exists(new_id)
    new_id
  end

  def GameStore.save(game:, id: GameStore.new_id)
    # record = begin
    #   GameStore.find(id)
    # rescue GameNotFound
    #   GameStore.new
    # end
    game.id = id
    expire_in_seconds = 3600
    options = { ex: expire_in_seconds }
    compressed_game = Zlib::Deflate.deflate(game.to_json)
    GameStore.persistence.set(id, compressed_game)
    id
    # record.json = game_object
    # record.save!
  end

  def GameStore.find(game_id)
    # records = GameStore.persistence.where(id: game_id)
    record = GameStore.persistence.get(game_id)
    raise GameNotFound if record.nil?
    Zlib::Inflate.inflate(record)
  end

  def GameStore.load(game_id)
    game_record = GameStore.find(game_id)
    GameFactory.from_json(game_record)
  end

  def GameStore.destroy(game_id)
    GameStore.persistence.del(game_id)
  end

  def GameStore.count
    GameStore.all_ids.size
  end

  def GameStore.all_ids
    cursor = 0
    all_keys = []
    begin
      (cursor, keys) = GameStore.persistence.scan(cursor)
      cursor = cursor.to_i
      all_keys = all_keys + keys
    end until cursor.zero?
    all_keys
  end
end
