Rails.application.routes.draw do
  resources :train_routes
  resources :stations
  # devise_for :users
  devise_for :users
  namespace "admin" do
    resources :users
  end
  root to: 'visitors#index'
end
