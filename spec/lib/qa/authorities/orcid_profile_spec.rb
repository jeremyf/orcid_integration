require 'spec_helper'
require 'ostruct'

module Qa::Authorities
  describe OrcidProfile do
    let(:user) { double }
    let(:email) { 'corwin@amber.gov' }
    let(:config) { {access_token: access_token, host: 'https://api.sandbox-1.orcid.org'} }
    let(:access_token) { '6e43b7b9-7d78-4fee-baa4-76acee469b7d' }
    let(:orcid_profile_id) { '0000-0001-8025-637X'}

    let(:request_headers) {
      {
        'Content-Type' => 'application/orcid+xml',
        'Accept' => 'application/orcid+json',
        'Authorization' => "Bearer #{access_token}"
      }
    }

    let(:response_headers) { {} }
    let(:json_response) { [ OpenStruct.new({ 'id' => orcid_profile_id, 'label' => "Corwin Amber (#{email}) [ORCID: #{orcid_profile_id}]" }) ] }

    before(:each) do
      stub_request(:get, File.join(config[:host], "v1.1/search/orcid-bio/?q=email:#{email}")).
        with(headers: request_headers).
        to_return(status: 200, headers: response_headers, body: response_body)
    end
    let(:parameters) { {q: "email:#{email}"} }

    context '#call' do
      subject { described_class.new(config) }
      it 'should return a JSON object' do
        expect(subject.call(parameters)).to eq(json_response)
      end
    end

    context '.call' do
      it 'should return a JSON object' do
        expect(described_class.call(parameters, config)).to eq(json_response)
      end
    end


    let(:response_body) {
      %(
        {
          "message-version": "1.1",
          "orcid-search-results": {
            "orcid-search-result": [
              {
                "relevancy-score": {
                  "value": 14.298138
                },
                "orcid-profile": {
                  "orcid": null,
                  "orcid-identifier": {
                    "value": null,
                    "uri": "http://orcid.org/#{orcid_profile_id}",
                    "path": "#{orcid_profile_id}",
                    "host": "orcid.org"
                  },
                  "orcid-bio": {
                    "personal-details": {
                      "given-names": {
                        "value": "Corwin"
                      },
                      "family-name": {
                        "value": "Amber"
                      }
                    },
                    "biography": {
                      "value": "King of Amber",
                      "visibility": null
                    },
                    "contact-details": {
                      "email": [
                        {
                          "value": "#{email}",
                          "primary": true,
                          "current": true,
                          "verified": true,
                          "visibility": null,
                          "source": null
                        }
                      ],
                      "address": {
                        "country": {
                          "value": "US",
                          "visibility": null
                        }
                      }
                    },
                    "keywords": {
                      "keyword": [
                        {
                          "value": "Lord of Amber"
                        }
                      ],
                      "visibility": null
                    },
                    "delegation": null,
                    "applications": null,
                    "scope": null
                  },
                  "orcid-activities": {
                    "affiliations": null
                  },
                  "type": null,
                  "group-type": null,
                  "client-type": null
                }
              }
            ],
            "num-found": 1
          }
        }
      )
    }
  end
end
