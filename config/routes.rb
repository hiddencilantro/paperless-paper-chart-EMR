Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#main'

  get '/providers/signup', to: 'providers#new'
  get '/providers/login', to: 'sessions#login'
  post '/providers/login', to: 'sessions#provider_authenticate'

  get '/patients/signup', to: 'patients#new'
  get '/patients/login', to: 'sessions#login'
  post '/patients/login', to: 'sessions#patient_authenticate'

  match '/logout', to: 'sessions#logout', via: [:get, :delete]

  resources :patients, except: [:index] do
    get 'search', on: :collection
    get 'directory', on: :collection
    resources :encounters, only: [:index, :create] do
      resources :soaps, only: [:new, :create]
    end
  end
  get '/patients', to: 'patients#directory'

  resources :providers, except: [:index, :edit, :update] do
    resources :patients, only: [:index, :new, :create]
  end

end
