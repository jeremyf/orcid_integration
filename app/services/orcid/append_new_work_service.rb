module Orcid
  class AppendNewWorkService
    def self.call(orcid_profile_id, body, config = {})
      new(config).call(orcid_profile_id, body)
    end

    attr_reader :headers, :token
    def initialize(config = {})
      @token = config.fetch(:token) { Orcid.client_credentials_token('/orcid-works/create') }
      @headers = config.fetch(:headers) { default_headers }
    end

    def call(orcid_profile_id, body)
      response = deliver(orcid_profile_id, body)
      parse(response)
    end

    protected
    def deliver(orcid_profile_id, body)
      path = "v1.1/#{orcid_profile_id}/orcid-works/"
      token.post(path, body: body, headers: headers)
    end

    def parse(response)
      !!response
    end

    def default_headers
      { 'Accept' => 'application/xml', 'Content-Type'=>'application/orcid+xml' }
    end

  end
end
