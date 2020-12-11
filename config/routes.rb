Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :regions
  resources :meters do 
    member do
      get 'hour'
      get 'day'
      get 'month'
    end
  end

  resources :reports
  resources :readings

  root to: 'meters#index'
end
