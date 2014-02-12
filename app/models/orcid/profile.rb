module Orcid
  class Profile

    attr_reader :orcid_profile_id
    def initialize(orcid_profile_id)
      @orcid_profile_id = orcid_profile_id
    end

    def append_new_work(work, config = {})
      remote_service = config.fetch(:remote_service) { Orcid::AppendNewWorkService }
      mapper = config.fetch(:mapper) { ::Mappy }
      orcid_work = mapper.map(work, target: 'orcid/work')

      remote_service.call(orcid_profile_id, orcid_work.to_xml)
    end

  end
end