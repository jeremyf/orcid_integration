OrcidIntegration::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: { omniauth_callbacks: 'devise/multi_auth/authentications' }

  namespace :orcid do
    resource :profile_request, only: [:show, :new, :create]
    resources :profile_connections, only: [:new, :create, :index]
  end
end
