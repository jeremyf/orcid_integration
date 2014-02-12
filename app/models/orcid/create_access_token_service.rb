module Orcid
  class CreateAccessTokenService
    def self.call(parameters, config = {})
      new(config).call(parameters)
    end

    def initialize(config = {})
      @host = config.fetch(:host) { Orcid.configuration.app_host }
      @client_id = config.fetch(:client_id) { Orcid.configuration.app_id }
      @client_secret = config.fetch(:client_secret) { Orcid.configuration.app_secret }
    end

    def call(parameters)
      response = deliver(payload(parameters))
      parse(response)
    end

    protected
    attr_reader :host, :client_id, :client_secret
    def payload(parameters)
      parameters.with_indifferent_access.reverse_merge(client_id: client_id, client_secret: client_secret)
    end

    def deliver(payload)
      RestClient.post(uri, payload, headers)
    end

    def parse(response)
      JSON.parse(response)
    end

    def uri
      File.join(host, "/oauth/token")
    end

    def headers
      {
        :accept => :json
      }
    end
  end
end