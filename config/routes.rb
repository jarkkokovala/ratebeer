Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beerclubs
  resources :users do
    post 'toggle_suspended', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :ratings, only: [:show, :index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]

  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  post 'places', to:'places#search'

  root 'breweries#index'
end