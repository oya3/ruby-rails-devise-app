# coding: utf-8
Rails.application.routes.draw do
  resources :between_train_route_stations do
    get :get_railway # 線路情報を取得する ajax api
  end

  resources :train_route_stations do
    put :sort # 並び替え ajax api
    get :get_railway # 線路情報を取得する ajax api
  end
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
