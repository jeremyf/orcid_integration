class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:github, :orcid]

  has_many :authentications, dependent: :destroy

  def self.find_by_provider_and_uid(provider, uid)
    includes(:authentications).
    where('authentications.provider = :provider AND authentications.uid = :uid', {provider: provider, uid: uid}).
    references(:authentications).first
  end

end
