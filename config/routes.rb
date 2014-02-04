OrcidIntegration::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: { omniauth_callbacks: :authentications }

  namespace :orcid do
    resources :profile_requests
  end
end
