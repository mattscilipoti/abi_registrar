Rails.application.routes.draw do
  resources :residents
  resources :properties
  resources :lots
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
