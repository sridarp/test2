Rails.application.routes.draw do
  # Docs
  apipie

  scope '/api/v1', except: [:new, :edit], defaults: { format: :json } do
    # Extensions
    mount_extensions

    # Auth
    devise_for :staff, controllers: { sessions: 'sessions' }

    devise_scope :staff do
      match '/staff/auth/:provider/callback', to: 'sessions#create', via: [:get, :post], defaults: { format: :html }
    end

    resources :saml, only: :index do
      collection do
        get :init
        get :sso
        post :acs
        get :metadata
        get :logout
      end
    end

    # Products & related
    resources :products
    resources :product_types, only: [:index, :show] do
      get 'async_select/:key', action: :async_select, on: :member
    end
    resources :product_categories

    # Settings
    resources :settings, only: [:index, :update], param: :name

    # Services
    resources :services, only: [:index, :show] do
      resources :operations, only: [:update], param: :operation, controller: :service_operations
    end

    # Orders
    resources :orders, only: [:index, :show, :create]

    # Extensions
    resources :extensions, only: [:index]

    # Logs
    get 'logs/:loggable_type/:loggable_id' => 'logs#index', as: :logs

    # Providers
    resources :providers do
      resources :product_types, only: [:index], controller: :provider_product_types
    end
    resources :registered_providers, only: [:index]

    # Alerts Routes
    resources :alerts do
      collection do
        post :sensu
      end
    end

    resources :wizard_questions do
      collection do
        get :first
      end
    end

    # Approvals
    resources :staff, only: [:index, :show, :create, :update, :destroy] do
      member do
        resources :permissions, only: [:show], param: :project_id, controller: :staff_permissions, as: :staff_permissions
      end
      collection do
        match 'current_member' => 'staff#current_member', via: :get
      end
    end

    # Organizations
    resources :organizations

    # Chargebacks
    resources :chargebacks

    resources :bundles

    # Project Routes
    resources :projects, only: [:index, :show, :create, :update, :destroy], defaults: { format: :json } do
      resources :services, only: [:index], controller: :project_services
      resources :memberships, only: [:index, :show, :create, :update, :destroy], shallow: true

      get 'approvals' => 'project_approvals#index', as: :project_approvals
      post 'approve' => 'project_approvals#update', as: :approve_project
      delete 'reject' => 'project_approvals#destroy', as: :reject_project
    end

    # ProjectQuestion Routes
    resources :project_questions do
      member do
        put :reposition
      end
    end

    # Content Pages Routes
    resources :content_pages, only: [:index, :create]
    resources :content_pages, only: [:update, :show, :destroy], param: :slug
    patch 'content_pages/revert/:slug', to: 'content_pages#revert'

    resources :groups do
      post 'staff/:staff_id' => 'associations#create'
      delete 'staff/:staff_id' => 'associations#destroy'
    end

    resources :roles, only: [:index, :show, :create, :update, :destroy]
    resources :tags, only: [:index]

    resource :version, only: [:show]

    # MOTD Routes
    resource :motd, only: [:create, :update, :show, :destroy]

    # Themes
    resource :theme, only: [:update, :show]
  end

  root 'welcome#index'

  match '*path' => 'welcome#index', via: :all
end
