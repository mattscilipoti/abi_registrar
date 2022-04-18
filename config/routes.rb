Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :lots
  resources :properties
  resources :residents

  # Defines the root path route ("/")
  # root "articles#index"
end
