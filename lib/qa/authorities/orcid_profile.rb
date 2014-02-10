require 'qa'
require 'ostruct'

module Qa::Authorities
  class OrcidProfile
    def self.call(query, config = {})
      new(config).call(query)
    end

    def initialize(config = {})
      @host = config.fetch(:host) { ENV['ORCID_APP_HOST'] }
      @access_token = config.fetch(:access_token) { Orcid.profile_search_access_token }
    end

    def call(parameters)
      response = deliver(parameters)
      parse(response.body)
    end
    alias_method :search, :call

    protected
    attr_reader :host, :access_token
    def deliver(parameters)
      RestClient.get(uri, headers.merge(params: parameters))
    end

    def parse(document)
      json = JSON.parse(document)

      json.fetch('orcid-search-results').fetch('orcid-search-result').each_with_object([]) do |result, returning_value|
        profile = result.fetch('orcid-profile')
        identifier = profile.fetch('orcid-identifier').fetch('path')
        orcid_bio = profile.fetch('orcid-bio')
        given_names = orcid_bio.fetch('personal-details').fetch('given-names').fetch('value')
        family_name = orcid_bio.fetch('personal-details').fetch('family-name').fetch('value')
        emails = orcid_bio.fetch('contact-details').fetch('email').collect {|email| email.fetch('value') }
        label = "#{given_names} #{family_name}"
        label << " (" << emails.join(",") << ")" if emails.present?
        label << " [ORCID: #{identifier}]"

        returning_value << OpenStruct.new("id" => identifier, "label" => label)
      end
    end

    def uri
      File.join(host, "v1.1/search/orcid-bio/")
    end

    def headers
      {
        :accept => 'application/orcid+json',
        'Authorization' => "Bearer #{access_token}",
        'Content-Type'=>'application/orcid+xml'
      }
    end

  end
end
