Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#main'

  get '/providers/login', to: 'sessions#provider_login'
  post '/providers/login', to: 'sessions#provider_authenticate'
  match '/logout', to: 'sessions#logout', via: [:get, :delete]

  resources :patients, only: [:index, :new, :create, :show] do
    get 'search', on: :collection
  end
  
  scope shallow_path: "provider", shallow_prefix: "provider" do
    resources :providers, only: [:new, :create, :show] do
      resources :patients, only: [:index, :new, :create, :show], shallow: true
    end
  end

end
