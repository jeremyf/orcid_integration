class Authentication < ActiveRecord::Base
  belongs_to :user

  def to_access_token(config = {})
    client = config.fetch(:client) { Orcid.oauth_client }
    tokenizer = config.fetch(:tokenizer) { OAuth2::AccessToken.method(:new) }
    tokenizer.call(client, access_token, refresh_token: refresh_token)
  end
end
