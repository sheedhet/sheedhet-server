Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/games/:id', to: 'games#show', as: 'game'

  get '/games/:id/players/:player_id', to: 'games#show'

  root 'pages#home'

  namespace :api do
    get '/games/:id', to: 'games#show'
    get '/games/:id/players/:player_id', to: 'games#show'
    put '/games/:id/players/:player_id', to: 'games#update'
    put '/games/:id', to: 'games#update'
  end

end
