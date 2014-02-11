module Orcid
  class ProfileConnection
    include Virtus.model
    include ActiveModel::Validations
    extend ActiveModel::Naming
    attribute :email
    attribute :orcid_profile_id
    attribute :user

    validates :user, presence: true
    validates :orcid_profile_id, presence: true

    def persisted?; false; end

    def save(config = {})
      persister = config.fetch(:persister) { Orcid.method(:connect_user_and_orcid_profile) }
      valid? ? persister.call(user, orcid_profile_id) : false
    end

    def with_orcid_profile_candidates
      if query_for_orcid_profile_candidates?
        yield(orcid_profile_candidates)
      end
    end
    attr_writer :orcid_profile_querier
    protected
    def orcid_profile_candidates
      @orcid_profile_candidates ||= begin
        if query_for_orcid_profile_candidates?
          orcid_profile_querier.call({q: "email:#{email}"}, {access_token: '', host: 'https://pub.orcid.org'} )
        else
          []
        end
      end
    end
    def query_for_orcid_profile_candidates?
      email.present?
    end

    def orcid_profile_querier
      @orcid_profile_querier ||= Qa::Authorities::OrcidProfile
    end
  end
end

