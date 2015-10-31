Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  get '/auth/twitter/failure', to: 'sessions#error', as: 'failure'
  get '/profile', to: 'sessions#show', as: 'profile'
  post '/profile', to: 'sessions#show', as: 'search'
  delete '/signout', to: 'sessions#destroy', as: 'signout'
  post '/retweet' => 'tweet#retweet'
  post '/favorite' => 'tweet#favorite'
  post '/reply' => 'tweet#reply'
  post '/lists' => 'tweet#lists'

end