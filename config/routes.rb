Rails.application.routes.draw do
  get 'home/main'
  devise_for :users
  resources :articles
  resources :publications, only: [:index, :edit, :destroy]
  resources :exhibitions, only: [:index, :edit, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#main"
end
