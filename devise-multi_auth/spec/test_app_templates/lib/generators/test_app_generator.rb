require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root "spec/test_app_templates"

  def install_devise
    generate 'devise:install'
    generate 'devise User'
  end

  def install_omniauth_strategies
    routing_code = %(, controllers: { omniauth_callbacks: 'devise/multi_auth/authentications' }\n)
    insert_into_file 'config/routes.rb', routing_code, { :after => /devise_for :users/, :verbose => false }

    config_code = ", :omniauthable, :omniauth_providers => [:github]"
    insert_into_file 'app/models/user.rb', config_code, { :after => /:validatable *$/, :verbose => false }

    init_code = %(\n  config.omniauth :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET'], :scope => 'user,public_repo')
    insert_into_file 'config/initializers/devise.rb', init_code, {after: /Devise\.setup.*$/, verbose: true}
  end

  def run_migrations
    rake 'devise_multi_auth:install:migrations'
  end
end
