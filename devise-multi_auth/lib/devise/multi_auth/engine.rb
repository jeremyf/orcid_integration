module Devise::MultiAuth
  class Engine < ::Rails::Engine
    isolate_namespace Devise::MultiAuth
    engine_name 'devise_multi_auth'

    initializer 'devise-multi_auth.initializers' do |app|
      app.config.paths.add 'app/services', eager_load: true
      app.config.autoload_paths += %W(
        #{config.root}/app/services
      )
    end

  end
end
