Rails.application.routes.draw do
  resources :styles
  resources :memberships do
    post 'set_confirmed', on: :member
  end
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

  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'
  
  root 'breweries#index'
end