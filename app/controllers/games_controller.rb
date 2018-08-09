class GamesController < ApplicationController
  def index
    @game_ids = GameStore.all_ids
  end

  # def new
  #   @game = GameFactory.build
  # end

  def create
    @game = GameFactory.build
    @id = GameStore.save(json: @game)
  end
  # DO STUFF IN TRANSACTIONS!
  def show
    @game_id = params[:id]
    game = begin
      GameStore.load(@game_id)
    rescue GameStore::GameNotFound
      new_game = GameFactory.build
      new_game.id = GameStore.save(game: new_game, id: params[:id])
      new_game
    end
    @position = params[:player_id].try(:to_i)
    game_hash = GameCensorer.censor(game: game, for_position: @position)
    @game = game_hash.to_json
  end

  def destroy
    @game = GameStore.destroy(params[:id])
    # @game.destroy
  end
end
