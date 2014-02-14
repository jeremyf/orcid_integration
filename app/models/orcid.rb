require 'orcid/configuration'

module Orcid
  class << self
    attr_accessor :configuration
  end

  module_function
  def configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def connect_user_and_orcid_profile(user, orcid_profile_id, options = {})
    Authentication.create!(provider: 'orcid', uid: orcid_profile_id, user: user)
  end

  def profile_for(object)
  end

  def enqueue(object)
    object.run
  end

  def oauth_client
    @oauth_client ||= OAuth2::Client.new(ENV['ORCID_APP_ID'], ENV['ORCID_APP_SECRET'], site: ENV['ORCID_SITE_URL'])
  end

  def client_credentials_token(scope, options = {})
    tokenizer = options.fetch(:tokenizer) { Orcid.oauth_client.client_credentials }
    tokenizer.get_token(scope: scope)
  end

  # @NOTE - The tokens may expire; This is presently not handled.
  def profile_search_access_token(options = {})
    creation_service = options.fetch(:creation_service) { Orcid.access_token_creation_service }
    cache[:profile_search_access_token] ||= creation_service.call(scope: '/read-public', grant_type:'client_credentials').fetch('access_token')
  end

  # @NOTE - The tokens may expire; This is presently not handled.
  def work_creation_access_token(options = {})
    creation_service = options.fetch(:creation_service) { Orcid.access_token_creation_service }
    cache[:work_creation_access_token] ||= creation_service.call(scope: '/orcid-works/create', grant_type:'client_credentials').fetch('access_token')
  end

  def cache
    @cache ||= {}
  end

  def reset_cache!
    @cache = {}
  end

end
