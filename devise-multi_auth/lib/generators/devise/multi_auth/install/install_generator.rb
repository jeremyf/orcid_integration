require 'rails/generators'

module Devise::MultiAuth
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def install_warden_initializer
      template('devise_multi_auth_initializer.rb.erb', 'config/initializers/devise_multi_auth_initializer.rb')
    end

    def install_migrations
      rake 'devise_multi_auth:install:migrations'
    end
  end
end
