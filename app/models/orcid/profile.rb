module Orcid
  class Profile

    attr_reader :orcid_profile_id
    def initialize(orcid_profile_id)
      @orcid_profile_id = orcid_profile_id
    end

    def append_new_work(work, config = {})
      remote_service = config.fetch(:remote_service) { Orcid::AppendNewWorkService }
      mapper = config.fetch(:mapper)
      orcid_work = mapper.map(work, target: 'Orcid::Work')

      remote_service.call(orcid_profile_id, orcid_work.to_xml)
    end

  end
end