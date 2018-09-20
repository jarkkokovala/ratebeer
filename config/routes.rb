Rails.application.routes.draw do
  resources :memberships
  resources :beerclubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:show, :index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]

  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  root 'breweries#index'
end