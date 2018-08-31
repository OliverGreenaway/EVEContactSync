Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: "home#index"
  get '/sync', to: 'sync#index'
  get '/settings/edit', to: 'settings#edit'
  put '/settings', to: 'settings#update'
end
