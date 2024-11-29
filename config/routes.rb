# Rails.application.routes.draw do
#   get "products/index"
#   get "products/show"
#   get "products/search", to: "products#search", as: "search_products"
#   root "home#index"
#   devise_for :admin_users, ActiveAdmin::Devise.config
#   ActiveAdmin.routes(self)
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Render dynamic PWA files from app/views/pwa/*
#   get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
#   get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

#   resources :products, only: [:show, :index] do
#     collection do
#       get :search
#     end
#     member do
#       post :add_to_cart
#       delete :remove_from_cart
#     end
#   end

#   resources :categories, only: [:index, :show] do
#     collection do
#       get :search
#     end
#   end

#   resources :carts, only: [:index] do
#     collection do
#       post 'add_product/:id', to: 'carts#add_product', as: 'add_product' # For adding a product to the cart
#     end
#     member do
#       patch 'update_quantity/:id', to: 'carts#update_quantity', as: 'update_quantity' # For updating the quantity of a specific product
#       delete 'remove_from_cart/:id', to: 'carts#remove_from_cart', as: 'remove_from_cart' # For removing a product from the cart
#     end
#   end

#   # Handle favicon requests
#   get '/favicon.ico', to: redirect('/assets/favicon.ico')

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Devise and ActiveAdmin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root path
  root "home#index"

  # Products routes
  resources :products, only: [:show, :index] do
    collection do
      get :search
    end
  end

  # Categories routes
  resources :categories, only: [:index, :show] do
    collection do
      get :search
    end
  end

  # Cart routes
  resources :carts, only: [:index] do
    collection do
      post 'add_product/:id', to: 'carts#add_product', as: 'add_product'       # Adding a product to the cart
      patch 'update_quantity/:id', to: 'carts#update_quantity', as: 'update_quantity' # Updating the quantity of a product
      delete 'remove_product/:id', to: 'carts#remove_from_cart', as: 'remove_product' # Removing a product from the cart
    end
  end


end
