Rails.application.routes.draw do

  get 'request_forms/items', to: 'request_forms#items'

  resources :employees
  resources :purchase_orders
  resources :particulars
  resources :request_forms 
  resources :canvasses
  resources :suppliers
  resources :products
  resources :quotations
  resources :projects
  resources :clients

  resources :companies do
    get 'clients', on: :member
    get 'suppliers', on: :member
    get 'request_forms', on: :member
    get 'projects', on: :member
    get 'canvasses', on: :member
    get 'quotations', on: :member
  end



  

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "main#index"
end
