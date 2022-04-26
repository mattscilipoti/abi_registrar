Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :lots
  resources :properties
  resources :purchase_shares, only: [:create, :index, :new, :show]
  resources :purchases
  resources :residents

  # Defines the root path route ("/")
  # root "articles#index"
  root to: redirect('/residents')
end
