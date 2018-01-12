module Api
  class GamesController < Api::ApplicationController
    def index
      @games = GameStore.all
    end

    def show
      game = GameStore.load(params[:id])
      game.update_valid_plays!
      game_hash = game.as_json
      position = params[:player_id].try(:to_i)
      censored_game_hash = GameCensorer.new(game_hash).for_position(position).censor
      censored_game_hash['id'] = params[:id] if params[:id].present?
      render json: censored_game_hash, status: :ok
    end

    def update
      game = GameStore.load(params[:id])
      # did the load fail?
      p "what in the fuck is params? #{params.inspect}"
      play_request = Play.from_json(params[:play].to_json)
      p "new play: #{play_request.inspect}"
      play_executor = PlayExecutor.new(game: game, play: play_request)
      # is the play valid?
      updated_game = play_executor.execute!
      GameStore.save(updated_game, params[:id])
      # did the save work?
      game_hash = updated_game.as_json
      position = play_request.position
      censored_game_hash = GameCensorer.new(game_hash).for_position(position).censor
      censored_game_hash['id'] = params[:id] if params[:id].present?
      render json: censored_game_hash, status: :ok
    end
  end
end