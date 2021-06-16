Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#main'

  resources :providers, only: [:new, :create, :show] do
    resources :patients, only: [:index]
  end
  
  get '/login', to: 'sessions#new'
end
