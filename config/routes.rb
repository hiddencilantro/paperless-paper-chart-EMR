Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#main'

  get '/providers/login', to: 'sessions#login'
  post '/providers/login', to: 'sessions#provider_authenticate'
  get '/patients/login', to: 'sessions#login'
  post '/patients/login', to: 'sessions#patient_authenticate'
  match '/logout', to: 'sessions#logout', via: [:get, :delete]

  resources :patients, except: [:index] do
    get 'search', on: :collection
    get 'all', on: :collection
  end

  resources :providers, except: [:index, :edit, :update] do
    resources :patients, only: [:index, :new, :create]
  end

end
