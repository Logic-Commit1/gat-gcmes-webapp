Rails.application.routes.draw do
  resources :scopes
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [] do
    member do
      patch :promote
    end
  end
  get 'request_forms/items', to: 'request_forms#items'
  get 'profile', to: 'profiles#show', as: :profile
  patch 'profile', to: 'profiles#update'
  delete 'profile/remove_signature', to: 'profiles#remove_signature', as: :remove_signature

  resources :employees do
    collection do
      get :whitelisted
    end
    member do
      patch :promote
      patch :demote
    end
  end
  resources :purchase_orders do
    member do
      get 'pdf_view'
      get 'print_pdf'
      get 'download_pdf'
      patch :approve
      patch :reject
      patch :pending
      delete :void
      patch :unvoid
      delete :delete
    end
  end
  resources :particulars
  resources :request_forms do
    member do
      get 'pdf_view'
      patch :approve
      patch :reject
      patch :pending
      delete :void
      patch :unvoid
      delete :delete
      get 'print_pdf'
      get 'download_pdf'
    end
  end
  resources :canvasses do
    member do
      get :pdf_view
      patch :approve
      patch :pending
      delete :void
      patch :unvoid
      get :download_pdf
      get :print_pdf
      patch :select_supplier
      delete :delete
    end
  end

  resources :suppliers
  resources :products
  resources :specs
  resources :quotations do
    member do
      get 'pdf_view'
      get 'pdf_preview'
      patch :approve
      patch :reject
      patch :pending
      delete :void
      patch :unvoid
      get 'print_pdf'
      get 'download_pdf'
      delete :delete
    end
  end
  resources :projects do
    member do
      delete :purge_attachment
    end
  end
  resources :clients do
    member do
      delete :destroy
    end
    get 'check_code', on: :collection
  end


  resources :companies do
    get 'clients', on: :member
    get 'suppliers', on: :member
    get 'order_request_forms', on: :member
    get 'projects', on: :member
    get 'canvasses', on: :member
    get 'quotations', on: :member
  end

  resources :voided_documents, only: [:index] do
    member do
      patch :unvoid
      delete :delete
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get 'main', to: 'main#index'
  
  # Defines the root path route ("/")
  root "quotations#index"
  # get 'employees/whitelisted', to: 'employees#whitelisted'
end
