module Orcid
  class Profile

    attr_reader :orcid_profile_id, :mapper, :remote_service
    private :mapper
    def initialize(orcid_profile_id, config = {})
      @orcid_profile_id = orcid_profile_id
      @mapper = config.fetch(:mapper) { ::Mappy }
      @remote_service = config.fetch(:remote_service) { Orcid::AppendNewWorkService }
    end

    def append_new_work(work, options = {})
      orcid_work = normalize_work(work)
      remote_service.call(orcid_profile_id, orcid_work.to_xml, :post)
    end

    def replace_works_with(works, options = {})
      xml_renderer = options.fetch(:xml_renderer)
      orcid_works = normalize_work(works)
      xml = xml_renderer.call(orcid_works)
      remote_service.call(orcid_profile_id, xml, :put)
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
