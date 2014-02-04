require 'spec_helper'

describe OrcidCreationService do
  let(:payload) {
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <orcid-message
    xmlns:xsi="http://www.orcid.org/ns/orcid https://raw.github.com/ORCID/ORCID-Source/master/orcid-model/src/main/resources/orcid-message-1.1.xsd"
    xmlns="http://www.orcid.org/ns/orcid">
    <message-version>1.1</message-version>
    <orcid-profile>
    <orcid-bio>
    <personal-details>
    <given-names>Albert</given-names>
    <family-name>Einstein</family-name>
    </personal-details>
    <contact-details>
    <email primary="true">a.einstein@orcid.org</email>
    </contact-details>
    </orcid-bio>
    </orcid-profile>
    </orcid-message>
    XML
  }

  let(:user) { double }
  let(:config) { {access_token: access_token, host: 'https://api.sandbox-1.orcid.org'} }
  let(:access_token) { '6e43b7b9-7d78-4fee-baa4-76acee469b7d' }
  subject { OrcidCreationService.new(config) }

  context '#call' do
    let(:minted_orcid) { '0000-0001-8025-637X' }
    let(:request_headers) {
      {
        'Content-Type' => 'application/vdn.orcid+xml',
        'Accept' => 'application/xml',
        'Authorization' => "Bearer #{access_token}"
      }
    }
    let(:response_headers) {
      {
        'Location' => File.join(config[:host], minted_orcid, "orcid-profile")
      }
    }

    before(:each) do
      stub_request(:post, File.join(config[:host], "v1.1/orcid-profile")).
        with(body: payload, headers: request_headers).
        to_return(status: 201, headers: response_headers)
    end

    context 'with valid data' do
      it 'should return the minted orcid' do
        expect(subject.call(payload)).to eq(minted_orcid)
      end
    end
  end
end
