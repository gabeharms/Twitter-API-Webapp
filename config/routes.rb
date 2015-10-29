Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/authenticate/callback', to: 'sessions#create', as: 'callback'
  get '/authenticate/failure', to: 'sessions#error', as: 'failure'
  get '/profile', to: 'sessions#show', as: 'profile'
  delete '/signout', to: 'sessions#destroy', as: 'signout'
  

end
