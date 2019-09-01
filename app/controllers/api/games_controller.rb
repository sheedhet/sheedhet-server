module Api
  class GamesController < Api::ApplicationController
    def index
      @game_ids = GameStore.all_ids
    end

    def show
      game = GameStore.load(params[:id])
      game.update_valid_plays!
      game_hash = game.as_json
      position = params[:player_id].try(:to_i)
      censored_game_hash = GameCensorer.censor(
        game: game_hash,
        for_position: position
      )
      censored_game_hash['id'] = params[:id] if params[:id].present?
      render(json: censored_game_hash, status: :ok)
    end

    def update
      play_executor = ExecutorFactory.build(
        game_id: params[:id],
        play_params: play_params
      )
      updated_game = play_executor.execute!
      _id = GameStore.save(game: updated_game, id: params[:id])
      # did the save work?
      redirect_to(action: :show, id: params[:id], status: :see_other)
    rescue GameStore::GameNotFound
      render json: { error: "Game ID #{params[:id]} not found" }, status: 404
    rescue PlayExecutor::InvalidPlayError, ExecutorFactory::BadPlayType => e
      render(json: { error: 'Invalid Play' }, status: :bad_request)
    end

    protected

    def play_params
      params.require(:play).permit(:destination, :position, hand: {})
    end
  end
end
