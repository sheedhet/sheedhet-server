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

  def load_game
    game = GameStore.load(params[:id])
    game = game.filtered_for(params[:player_id].to_i) if params[:player_id].present?
    game
  end

  def show
    game = load_game
    @game = game.as_json.to_json
    respond_to do |format|
      format.html
      format.json { render json: @game }
    end
  end

  def filtered_for
    unfiltered_game = GameStore.load(params[:game_id])
    @game = unfiltered_game.filtered_for(params[:player_id])
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
