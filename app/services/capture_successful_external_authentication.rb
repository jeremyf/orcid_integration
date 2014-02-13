class CaptureSuccessfulExternalAuthentication
  def self.call(user, auth = {})
    return true unless auth.present?
    new(user, auth).call
  end

  attr_accessor :user, :auth
  def initialize(user, auth)
    @user = user
    @auth = auth
  end

  def call
    Authentication.where(user: user).where(auth.slice(:provider, :uid)).first_or_create do |object|
      object.access_token = auth.fetch(:credentials)[:token]
      object.refresh_token = auth.fetch(:credentials)[:refresh_token]
    end
  end
end