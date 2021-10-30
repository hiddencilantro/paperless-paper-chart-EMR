Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#main'

  get '/providers/login', to: 'sessions#login'
  post '/providers/login', to: 'sessions#provider_auth'
  get '/patients/login', to: 'sessions#login'
  post '/patients/login', to: 'sessions#patient_auth'
  match '/logout', to: 'sessions#logout', via: [:get, :delete]

  get 'auth/:provider/callback', to: 'sessions#google_auth'
  get 'auth/failure', to: redirect('/')

  resources :providers, only: [:new, :create, :show] do
    resources :patients, only: [:index, :new, :create]
  end

  get '/patients', to: 'patients#directory'
  resources :patients, except: [:index] do
    collection do
      get :search
      get :directory
    end
    resources :encounters
  end

end
