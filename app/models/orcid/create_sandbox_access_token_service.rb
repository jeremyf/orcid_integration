require 'rest-client'
module Orcid

  # Responsible for requesting access tokens
  #
  # Note Orcid::CreateSandboxAccessTokenService.call and Orcid::CreateAccessTokenService.call
  # should have the same structured output.
  #
  # This class encapsulates the CURL method for generating access tokens.
  # http://support.orcid.org/knowledgebase/articles/179969-methods-to-generate-an-access-token-for-testing
  class CreateSandboxAccessTokenService
    def self.call(options = {}, config = {})
      new(config).call(options)
    end

    attr_reader :host, :orcid_profile_id, :password, :access_scope, :cookies
    attr_reader :oauth_redirect_uri, :orcid_client_id, :authorization_code, :orcid_client_secret

    def initialize(options = {})
      @orcid_profile_id = options.fetch(:orcid_profile_id) { ENV['ORCID_SANDBOX_EXISTING_PROFILE_ID'] }
      @orcid_client_id = options.fetch(:orcid_client_id) { ENV['ORCID_SANDBOX_APP_ID']}
      @orcid_client_secret = options.fetch(:orcid_client_secret) { ENV['ORCID_SANDBOX_APP_SECRET']}
      @password = options.fetch(:password) { ENV['ORCID_SANDBOX_EXISTING_PROFILE_PASSWORD']}
      @host = options.fetch(:host) { "https://sandbox-1.orcid.org" }
      @oauth_redirect_uri = options.fetch(:oauth_redirect_uri) { 'https://developers.google.com/oauthplayground' }
    end

    attr_writer :cookies
    private :cookies
    def call(options = {})
      access_scope = options.fetch(:scope) { '/orcid-profile/read-limited' }
      grant_type = options.fetch(:grant_type) { 'authorization_code' }

      login_to_orcid(access_scope)
      request_authorization(access_scope)
      request_authorization_code(access_scope)
      exchange_authorization_code_for_access_token(access_scope, grant_type)
    end

    def login_to_orcid(access_scope)
      uri = File.join(host, "/signin/auth.json")
      response = RestClient.post(uri, userId: orcid_profile_id, password: password )
      if ! JSON.parse(response)["success"]
        raise "Response not successful: \n#{response}"
      else
        self.cookies = response.cookies
      end
    end

    def request_authorization(access_scope)
      parameters = { client_id: orcid_client_id, response_type: 'code', scope: access_scope, redirect_uri: oauth_redirect_uri }
      uri = File.join(host, "oauth/authorize")
      RestClient.get(uri, {params: parameters, cookies: cookies})
    end

    def request_authorization_code(access_scope)
      uri = File.join(host, 'oauth/authorize')
      RestClient.post(uri, {user_oauth_approval: true}, {cookies: cookies})
    rescue RestClient::Found => e
      uri = URI.parse(e.response.headers.fetch(:location))
      @authorization_code = CGI::parse(uri.query).fetch('code').first
    end

    def exchange_authorization_code_for_access_token(access_scope, grant_type)
      headers = {accept: :json}
      payload = {
        client_id: orcid_client_id,
        client_secret: orcid_client_secret,
        grant_type: grant_type,
        code: authorization_code,
        scope: access_scope,
        redirect_uri: oauth_redirect_uri
      }
      uri = File.join("http://api.sandbox-1.orcid.org", 'oauth/token')
      response = RestClient.post(uri, payload, headers)
      JSON.parse(response.body)
    end

  end
end
