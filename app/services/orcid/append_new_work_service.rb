module Orcid
  class AppendNewWorkService
    def self.call(orcid_profile_id, body, config = {})
      new(orcid_profile_id, body, config).call
    end

    attr_reader :headers, :token, :orcid_profile_id, :body
    def initialize(orcid_profile_id, body, config = {})
      @orcid_profile_id = orcid_profile_id
      @body = body
      @token = config.fetch(:token) { Orcid.access_token_for(orcid_profile_id) }
      @headers = config.fetch(:headers) { default_headers }
    end

    def call
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
