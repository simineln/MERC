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
      get 'xml_generator'
    end
  end

  resources :reports
  resources :readings

  get 'send_mail' => 'send_mail#index'
  get 'send_json' => 'send_json#index'


  root to: 'meters#index'


end
