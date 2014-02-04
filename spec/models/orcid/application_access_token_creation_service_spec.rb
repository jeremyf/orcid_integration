require 'spec_helper'

module Orcid
  describe ApplicationAccessTokenCreationService do
    let(:config) {
      {
        client_id: '0000-0002-9189-9910',
        host: 'https://api.sandbox-1.orcid.org',
        client_secret: '719b5c31-5681-4dce-a317-ff1bc1e94288'
      }
    }

    let(:request_headers) { { 'Accept' => 'application/json'} }
    let(:post_parameters) { { 'scope'=>'/orcid-profile/create', 'grant_type'=>'client_credentials' } }
    let(:response_body) {
      {
        "access_token"=>"6e43b7b9-7d78-4fee-baa4-76acee469b7d",
        "token_type"=>"bearer",
        "refresh_token"=>"5d9dc734-73c8-4f66-8548-194ead7ddf73",
        "expires_in"=>631138518,
        "scope"=>"/orcid-record/create"
      }
    }
    let(:response_header) { {'Content-Type' => 'application/json'} }

    before(:each) do
      stub_request(:post, File.join(config[:host], "/oauth/token")).
        with(headers: request_headers, body: hash_including(post_parameters)).
        to_return(body: response_body.to_json, headers: response_header, status: 200)

    end

    context '#call' do
      subject { described_class.new(config) }
      it do
        expect(subject.call(post_parameters)).to eq(response_body)
      end
    end

  end
end
