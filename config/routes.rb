Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: "home#index"
  get '/manual', to: 'home#manual'
  get '/dashboard', to: 'dashboard#index'
  get '/admin', to: 'admin#index'
  get '/settings/edit', to: 'settings#edit'
  put '/settings', to: 'settings#update'
  put '/settings/premium', to: 'settings#premium_settings'
  post '/synchronize', to: 'dashboard#synchronize'
  get '/premium', to: 'premium#index'
  delete '/alt_character', to: 'dashboard#remove_alt'

  devise_scope :user do
     get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
end
