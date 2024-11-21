Rails.application.routes.draw do
  get "products/index"
  get "products/show"
  get "products/search", to: "products#search", as: "search_products"
  root "home#index"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  resources :products, only: [:show, :index] do
    collection do
      get :search
    end
  end
  resources :categories, only: [:index, :show] do
    collection do
      get :search
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
