Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }
  resources :users, only: [:index, :show, :create], format: 'json'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
