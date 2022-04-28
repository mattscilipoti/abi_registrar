Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :lots
  resources :properties
  resources :share_transactions, only: [:create, :index, :new, :show]
  resources :item_transactions
  resources :residents

  # Defines the root path route ("/")
  # root "articles#index"
  root to: redirect('/residents')
end
