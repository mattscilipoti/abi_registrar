Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  constraints Rodauth::Rails.authenticated do
    get 'summary', to: 'pages#summary'

    resources :accounts, only: [:index]
    resources :beach_passes do
      member do
        get :void
        patch :confirm_void
      end
    end
    resources :boat_ramp_access_passes
    resources :comments, only: [:create]
    resources :dinghy_dock_storage_passes
    resources :lots
    resources :item_transactions
    resources :properties
    resources :residents
    resources :residencies, only: [:index, :show, :update]
    resources :share_transactions, only: [:create, :index, :new, :show] do
      collection do
        get :purchase_new, as: :purchase_new
        post :purchase
        get :transfer_new, as: :transfer_new
        post :transfer
      end
    end
    resources :utility_cart_passes
    resources :vehicle_parking_passes
    resources :watercraft_storage_passes
  end

  get 'home', to: 'pages#home'
  get 'year_end', to: 'year_end#index'
  post 'reset_fees', to: 'year_end#reset_fees'
  resources :amenity_passes, only: [:index] # must be unauthenticated for "public" access

  # Defines the root path route ("/")
  # root "articles#index"
  root to: redirect('/home')
end
