Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: "home#index"
  get '/dashboard', to: 'dashboard#index'
  get '/admin', to: 'admin#index'
  get '/settings/edit', to: 'settings#edit'
  put '/settings', to: 'settings#update'
  post '/synchronize', to: 'dashboard#synchronize'

  devise_scope :user do
     get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
end
