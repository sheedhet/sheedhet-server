class GamesController < ApplicationController
  def index
    @games = GameStore.all
  end

  def new
    @game = GameFactory.build
  end

  def show
    @game_id = params[:id]
    game = begin
      GameStore.load(@game_id)
    rescue GameStore::GameNotFound
      new_game = GameFactory.build
      GameStore.save(json: new_game.to_json, id: params[:id])
      new_game
    end
    @position = params[:player_id].try(:to_i)
    game_hash = GameCensorer.censor(game: game, for_position: @position)
    @game = game_hash.to_json
  end

  def destroy
    @game = GameStore.find(params[:id])
    @game.destroy
  end
end
