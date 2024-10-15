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
      post 'create_payment_intent'
    end
    resources :job_applications, only: [:new, :create]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end




