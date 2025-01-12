Rails.application.routes.draw do
  get "pages/show"
  get "checkout/new"
  get 'order_confirmation/:id', to: 'orders#confirmation', as: 'order_confirmation'

  get 'contact', to: 'pages#show', id: 'contact', as: :contact
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

  # About page
  resources :pages, only: [:show] do
    collection do
      get '/about', to: 'pages#show', id: 'about', as: :about_page
    end
  end

  # Categories routes
  resources :categories, only: [:index, :show] do
    collection do
      get :search
    end
  end

  # Checkout Routes
  resources :checkout, only: [:new, :create] 
  scope '/checkout' do
    post 'create', to: "checkout#create", as: :checkout_create
    get 'success', to: 'checkout#success', as: :checkout_success
    get 'cancel', to: 'checkout#cancel', as: :checkout_cancel

  end

  # Cart routes
  resources :carts, only: [:index] do
    collection do
      post 'add_product/:id', to: 'carts#add_product', as: 'add_product'       # Adding a product to the cart
      patch 'update_quantity/:id', to: 'carts#update_quantity', as: 'update_quantity' # Updating the quantity of a product
      delete 'remove_product/:id', to: 'carts#remove_from_cart', as: 'remove_product' # Removing a product from the cart
      delete 'clear', to: 'carts#clear', as: 'clear_cart' # Clearing the entire cart
    end
  end


end
