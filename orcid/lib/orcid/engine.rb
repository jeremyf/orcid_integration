module Orcid
  class Engine < ::Rails::Engine
    isolate_namespace Orcid
    config.orcid = Orcid

    initializer 'orcid.initializers' do |app|
      app.config.paths.add 'app/services', eager_load: true
      app.config.autoload_paths += %W(
        #{config.root}/app/services
      )
    end

    config.before_initialize do |app|
      app.config.orcid.configure do |config|
        config.provider_name = 'orcid'
      end
    end

  end
end
