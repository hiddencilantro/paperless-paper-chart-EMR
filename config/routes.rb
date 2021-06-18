Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#main'

  get '/providers/login', to: 'sessions#provider_login'
  post '/providers/login', to: 'sessions#provider_authenticate'

  resources :providers, only: [:new, :create, :show] do
    resources :patients, only: [:index, :show, :new, :create]
  end

end
