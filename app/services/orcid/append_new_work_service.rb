module Orcid
  class AppendNewWorkService
    def self.call(orcid_profile_id, payload, options = {})
      new(options).call(orcid_profile_id, payload)
    end

    attr_reader :host, :access_token
    def initialize(config)
      @host = config.fetch(:host) { Orcid.configuration.app_host }
      @access_token = config.fetch(:access_token) { Orcid.work_creation_access_token }
    end

    def call(orcid_profile_id, payload)
      response = deliver(orcid_profile_id, payload)
      parse(response)
    end

    protected
    def deliver(orcid_profile_id, payload)
      RestClient.post(uri(orcid_profile_id), payload, headers)
    end

    def parse(response)
      !!response
    end

    def uri(orcid_profile_id)
      File.join(host, "v1.1/#{orcid_profile_id}/orcid-works/")
    end

    def headers
      {
        :accept => :xml,
        'Authorization' => "Bearer #{access_token}",
        'Content-Type'=>'application/orcid+xml'
      }
    end

  end
end
