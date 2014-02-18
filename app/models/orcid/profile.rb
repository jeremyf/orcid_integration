module Orcid
  class Profile

    attr_reader :orcid_profile_id, :mapper, :remote_service, :xml_renderer
    private :mapper
    def initialize(orcid_profile_id, config = {})
      @orcid_profile_id = orcid_profile_id
      @mapper = config.fetch(:mapper) { ::Mappy }
      @remote_service = config.fetch(:remote_service) { Orcid::AppendNewWorkService }
      @xml_renderer = config.fetch(:xml_renderer) { Orcid::Work::XmlRenderer }
    end

    def append_new_work(*works)
      orcid_works = normalize_work(*works)
      xml = xml_renderer.call(orcid_works)
      remote_service.call(orcid_profile_id, xml, :post)
    end

    def replace_works_with(*works)
      orcid_works = normalize_work(*works)
      xml = xml_renderer.call(orcid_works)
      remote_service.call(orcid_profile_id, xml, :put)
    end

    protected

    # Note: We can handle
    def normalize_work(*works)
      Array(works).flatten.compact.collect do |work|
        if work.is_a?(Orcid::Work)
          work
        else
          mapper.map(work, target: 'orcid/work')
        end
      end
    end

  end
end
