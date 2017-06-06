Rails.application.routes.draw do
  # devise_for :users
  devise_for :users
  resources :users, :only => [:index, :show]
  root to: 'visitors#index'
end
