module Orcid
  class Profile

    attr_reader :orcid_profile_id
    def initialize(orcid_profile_id)
      @orcid_profile_id = orcid_profile_id
    end

    def append_new_work(work, config = {})
      remote_service = config.fetch(:remote_service) { Orcid::AppendNewWorkService }
      work_to_orcid_xml_transformer = config.fetch(:to_orcid_xml_mapper)

      xml = work_to_orcid_xml_transformer.call(work)
      remote_service.call(orcid_profile_id, xml)
    end

  end
end