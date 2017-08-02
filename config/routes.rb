Rails.application.routes.draw do
  get 'games/index'

  get 'games/new'

  # get 'games/create'

  get '/games/:id', to: 'games#show', as: 'game'

  get '/games/:id/players/:player_id', to: 'games#show'

  # get 'games/edit'

  # get 'games/update'

  get 'games/destroy'

  root 'pages#home'
end
