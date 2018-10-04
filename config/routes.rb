Rails.application.routes.draw do
  resources :memberships
  resources :beerclubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:show, :index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]

  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  post 'places', to:'places#search'

  root 'breweries#index'
end