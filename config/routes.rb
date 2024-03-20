Rails.application.routes.draw do
  post '/users', to: 'users#create'
  post '/sessions', to: 'sessions#create'
  get '/authenticated', to: 'sessions#authenticated'
  delete '/sessions', to: 'sessions#destroy'
  post '/tweets', to: 'tweets#create'
  delete '/tweets/:id', to: 'tweets#destroy'
  get '/tweets', to: 'tweets#index'
  get '/users/:username/tweets', to: 'tweets#index_by_user'
end
