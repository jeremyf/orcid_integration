module Orcid
  # Responsible for:
  # * acknowledging that an ORCID Profile was requested
  # * submitting a request for an ORCID Profile
  # * handling the response for the ORCID Profile creation
  class ProfileRequest < ActiveRecord::Base
    self.table_name = :orcid_profile_requests

    validate :user_id, presence: true, unique: true
    belongs_to :user

    serialize :payload_attributes

    def submit(options = {})
      # Why dependency injection? Because this is going to be a plugin, and things
      # can't possibly be simple.
      before_submit_validator = options.fetch(:before_submit_validator) { method(:validate_before_submit) }
      return false unless before_submit_validator.call(self)

      payload_xml_builder = options.fetch(:payload_xml_builder) { method(:xml_payload) }
      profile_creation_service = options.fetch(:profile_creation_service) { Orcid::ProfileCreationService }
      profile_creation_responder = options.fetch(:profile_creation_responder) { method(:handle_profile_creation_response) }

      orcid_profile_id = profile_creation_service.call(payload_xml_builder.call(payload_attributes))
      profile_creation_responder.call(orcid_profile_id)
    end

    def validate_before_submit(context = self)

      if context.orcid_profile_id?
        context.errors.add(:base, "#{context.class} ID=#{context.to_param} already has an assigned :orcid_profile_id #{context.orcid_profile_id.inspect}")
        return false
      end

      if user_orcid_profile = Orcid.profile_for(context.user)
        context.errors.add(:base, "#{context.class} ID=#{context.to_param}'s associated user #{context.user.to_param} already has an assigned :orcid_profile_id #{user_orcid_profile.to_param}")
        return false
      end

      true
    end

    # As per http://support.orcid.org/knowledgebase/articles/177522-create-an-id-technical-developer
    def xml_payload(input = payload_attributes)
      attrs = input.with_indifferent_access
      <<-XML_TEMPLATE
      <?xml version="1.0" encoding="UTF-8"?>
      <orcid-message xmlns="http://www.orcid.org/ns/orcid">
      <orcid-record>
      <orcid-bio>
      <personal-details>
      <given-names>#{attrs.fetch('given_names')}</given-names>
      <family-name>#{attrs.fetch('family_name')}</family-name>
      </personal-details>
      <contact-details>
      <email primary="true">#{attrs.fetch('primary_email')}</email>
      </contact-details>
      </orcid-bio>
      </orcid-record>
      </orcid-message>
      XML_TEMPLATE
    end

    def handle_profile_creation_response(orcid_profile_id)
      self.class.transaction do
        update_column(:orcid_profile_id, orcid_profile_id)
        user.attach_orcid_profile_id(orcid_profile_id)
      end
    end

  end
end
