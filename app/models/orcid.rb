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

  def access_token_for(orcid_profile_id, options = {})
    Authentication.where(uid: orcid_profile_id, provider: 'orcid').first.
      to_access_token(client: oauth_client)
  end

  def profile_for(user)
    if authentication = Authentication.where(provider: 'orcid', user: user).first
      Orcid::Profile.new(authentication.uid)
    else
      nil
    end
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

  def cache
    @cache ||= {}
  end

  def reset_cache!
    @cache = {}
  end

end
