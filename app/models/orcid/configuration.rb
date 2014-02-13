module Orcid
  class Configuration
    attr_reader :store
    def initialize(store = ::ENV)
      @store = store
    end

    attr_writer :app_id, :app_secret, :app_host
    def app_id
      @app_id ||= store.fetch('ORCID_APP_ID')
    end

    def app_secret
      @app_secret ||= store.fetch('ORCID_APP_SECRET')
    end

    def app_host
      @app_host ||= store.fetch('ORCID_SITE_URL')
    end
  end
end