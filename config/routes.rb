Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'reports/barchart'
      get 'reports/piechart'
      get 'reports/linegraph'
    end
  end
  get 'home/main'
  devise_for :users
  get 'articles/download'
  post 'import', to: 'articles#import', as: :import
  resources :articles
  resources :publications, only: [:index, :edit, :destroy]
  resources :exhibitions, only: [:index, :edit, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#main"
end
