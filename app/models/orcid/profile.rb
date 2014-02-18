module Orcid
  class Profile

    attr_reader :orcid_profile_id, :mapper
    private :mapper
    def initialize(orcid_profile_id, config = {})
      @orcid_profile_id = orcid_profile_id
      @mapper = config.fetch(:mapper) { ::Mappy }
    end

    def append_new_work(work, options = {})
      remote_service = options.fetch(:remote_service) { Orcid::AppendNewWorkService }
      orcid_work = normalize_work(work)
      remote_service.call(orcid_profile_id, orcid_work.to_xml)
    end

    protected

    def normalize_work(work)
      if work.is_a?(Orcid::Work)
        work
      else
        mapper.map(work, target: 'orcid/work')
      end
    end

  end
end
