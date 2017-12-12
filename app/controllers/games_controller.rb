class GamesController < ApplicationController
  def index
    @games = GameStore.all
  end

  def new
    @game = GameFactory.build
  end

  def show
    game = GameStore.load(params[:id])
    game_hash = game.as_json
    position = params[:player_id].try(:to_i)
    game_hash = GameCensorer.new(game_hash).for_position(position).censor
    @position = position
    @game_id = params[:id]
    @game = game_hash.to_json
  end

  def destroy
    @game = GameStore.find(params[:id])
    @game.destroy
  end
end
