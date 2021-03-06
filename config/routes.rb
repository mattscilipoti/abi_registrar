Rails.application.routes.draw do
  constraints Rodauth::Rails.authenticated do

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    get 'summary', to: 'pages#summary'

    resources :accounts, only: [:index]
    resources :comments, only: [:create]
    resources :lots
    resources :item_transactions
    resources :properties
    resources :residents
    resources :residencies, only: [:index, :show]
    resources :share_transactions, only: [:create, :index, :new, :show] do
      collection do
        get :purchase_new, as: :purchase_new
        post :purchase
        get :transfer_new, as: :transfer_new
        post :transfer
      end
    end
    resources :vehicles
  end
  # Defines the root path route ("/")
  # root "articles#index"
  root to: redirect('/summary')
end
