class GamesController < ApplicationController
  # index
  # new
  # create
  # show
  # edit
  # update
  # destroy
  def index
    @games = GameStore.all
  end

  def new
    @game = GameFactory.build
  end

  # might not need a create method if we only save after a successful turn
  # def create
  #   @game = GameFactory.build(params[:game])
  #   GameStore.save(game)
  # end

  def show
    game = GameStore.load(params[:id])
    game.update_valid_plays
    game_hash = game.as_json
    position = params[:player_id].try(:to_i)
    game_hash = GameCensorer.new(game_hash).for_position(position).censor
    @position = position
    game_hash['id'] = params[:id] if params[:id].present?
    @game = game_hash.to_json
  end

  # maybe roll this into a different route?
  # def edit
  #   play = params[play]
  #   game = GameStore.find(play.game_id)
  #   game.do_turn play
  # end

  # def update
  #   GameStore.update!(params[game])
  # end

  def destroy
    @game = GameStore.find(params[:id])
    @game.destroy
  end
end
