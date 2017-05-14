Rails.application.draw do
  root 'events#index'

  resources :events
  resources :users, only: [:show, :edit, :update]
end