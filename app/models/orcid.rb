module Orcid
  module_function

  def profile_for(object)
  end

  def enqueue(object)
    object.run
  end

  # @NOTE - The tokens may expire; This is presently note handled.
  def profile_creation_access_token(options = {})
    creation_service = options.fetch(:creation_service) { Orcid::ApplicationAccessTokenCreationService }
    cache[:profile_creation_access_token] ||= creation_service.call(scope: '/orcid-profile/create', grant_type:'client_credentials').fetch('access_token')
  end

  # @NOTE - The tokens may expire; This is presently note handled.
  def profile_search_access_token(options = {})
    creation_service = options.fetch(:creation_service) { Orcid::ApplicationAccessTokenCreationService }
    cache[:profile_creation_access_token] ||= creation_service.call(scope: '/read-public', grant_type:'client_credentials').fetch('access_token')
  end

  def cache
    @cache ||= {}
  end

  def reset_cache!
    @cache = {}
  end

end
