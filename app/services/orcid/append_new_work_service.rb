module Orcid
  class AppendNewWorkService
    def self.call(orcid_profile_id, body, request_method, config = {})
      new(orcid_profile_id, body, request_method, config).call
    end

    attr_reader :headers, :token, :orcid_profile_id, :body, :request_method
    def initialize(orcid_profile_id, body, request_method = :post, config = {})
      @orcid_profile_id = orcid_profile_id
      @request_method = request_method
      @body = body
      @token = config.fetch(:token) { Orcid.access_token_for(orcid_profile_id) }
      @headers = config.fetch(:headers) { default_headers }
    end

    # :post will append works to the Orcid Profile
    # :put will replace the existing Orcid Profile works with the payload
    # http://support.orcid.org/knowledgebase/articles/177528-add-works-technical-developer
    def call
      response = deliver(orcid_profile_id, body)
      parse(response)
    end

    protected
    def deliver(orcid_profile_id, body)
      path = "v1.1/#{orcid_profile_id}/orcid-works/"
      token.request(request_method, path, body: body, headers: headers)
    end

    def parse(response)
      !!response
    end

    def default_headers
      { 'Accept' => 'application/xml', 'Content-Type'=>'application/orcid+xml' }
    end

  end
end
