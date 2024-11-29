Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Devise and ActiveAdmin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

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
