Rails.application.routes.draw do
  resources :user_stocks
  get 'stocks/search'
  get 'users/my_portfolio'
  devise_for :users
  root 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stock', to: 'stocks#search'
  get 'my_friend', to: 'users#friends_stock'
  get 'search_friend', to: 'users#search'
  post 'create_friend', to: 'users#create_friend'
  delete 'destroy_friend', to: 'users#destroy_friend'
  get 'show_profile', to: 'users#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
