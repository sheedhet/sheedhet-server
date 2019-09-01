module ExecutorFactory
  class BadPlayType < ArgumentError; end

  def self.build(game_id:, play_params:)
    case play_params[:destination]
    when 'play_pile'
      PlayExecutor.new(game_id: game_id, play_params: play_params)
    when 'in_hand'
      PickupPlayExecutor.new(game_id: game_id, play_params: play_params)
    when 'swap'
      SwapPlayExecutor.new(game_id: game_id, play_params: play_params)
    when /^flip/
      FlipPlayExecutor.new(game_id: game_id, play_params: play_params)
    else
      raise BadPlayType, "Unknown play type: #{play_params[:destination]}"
    end
  end
end
