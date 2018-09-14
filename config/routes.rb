Rails.application.routes.draw do
  root 'breweries#index'

  resources :beers
  resources :breweries
  resources :ratings, only: [:show, :index, :new, :create, :destroy]
end