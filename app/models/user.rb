class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:github]

  has_many :authentications, dependent: :destroy

  def self.new_with_session(params, session)
    super.tap do |user|
      if auth_data = session['devise.auth_data']
        user.authentications.build(
          provider: auth_data.fetch('provider'),
          uid: auth_data.fetch('uid')
        )
      end
    end
  end

  def self.find_by_provider_and_uid(provider, uid)
    includes(:authentications).
    where('authentications.provider = :provider AND authentications.uid = :uid', {provider: provider, uid: uid}).
    references(:authentications).first
  end
end
