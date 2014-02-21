OrcidIntegration::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: { omniauth_callbacks: 'devise/multi_auth/authentications' }

  mount Orcid::Engine, at: '/orcid'
end
