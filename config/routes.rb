Rails.application.routes.draw do
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  # Set the root path to the jobs index
  root 'jobs#index'
  
  # Your other routes...
  devise_for :users
  resources :jobs do
    collection do
      post 'filter'
    end
    member do
      post 'bookmark'
      delete 'unbookmark'
      get 'apply'
    end
    resources :job_applications do
      member do
        get :confirmation
      end
    end
  end

  resources :payments, only: [:new, :create] do
    collection do
      get :success
      get :cancel
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'my_jobs', to: 'jobs#my_jobs'

  # Remove these routes if they're not used elsewhere
  # get 'locations/states', to: 'locations#states'
  get 'cities', to: 'locations#cities'

  get 'locations/regions', to: 'locations#regions'
  get 'locations/cities', to: 'locations#cities'
end





