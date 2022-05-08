Rails.application.routes.draw do
  resources :vehicles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :comments, only: [:create]
  resources :lots
  resources :properties
  resources :share_transactions, only: [:create, :index, :new, :show] do
    collection do
      get :purchase_new, as: :purchase_new
      post :purchase
      get :transfer_new, as: :transfer_new
      post :transfer
    end
  end
  resources :item_transactions
  resources :residents

  # Defines the root path route ("/")
  # root "articles#index"
  root to: redirect('/residents')
end
