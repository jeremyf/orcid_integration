module Orcid
  class Profile

    attr_reader :orcid_profile_id
    def initialize(orcid_profile_id)
      @orcid_profile_id = orcid_profile_id
    end

    def append_new_work(work, config = {})
      remote_service = config.fetch(:remote_service) { Orcid::AppendNewWorkService }
      token = config.fetch(:token) { Orcid.access_token_for(orcid_profile_id) }
      orcid_work = normalize_work(work, config)

      remote_service.call(orcid_profile_id, orcid_work.to_xml, token: token)
    end

    protected

    def normalize_work(work,config)
      if work.is_a?(Orcid::Work)
        orcid_work = work
      else
        mapper = config.fetch(:mapper) { ::Mappy }
        orcid_work = mapper.map(work, target: 'orcid/work')
      end
    end

  end
end
