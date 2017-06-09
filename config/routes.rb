Rails.application.routes.draw do
  resources :train_routes
  resources :stations
  devise_for :users
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  namespace "admin" do
    resources :users
  end
  root to: 'visitors#index'
end
