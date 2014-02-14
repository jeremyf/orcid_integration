require 'spec_helper'

module Orcid
  describe AppendNewWorkService do
    let(:payload) { %(<?xml version="1.0" encoding="UTF-8"?>) }
    let(:user) { double }
    let(:config) { {access_token: access_token, host: 'https://api.sandbox-1.orcid.org'} }
    let(:access_token) { '6e43b7b9-7d78-4fee-baa4-76acee469b7d' }
    let(:orcid_profile_id) { '0000-0003-1495-7122' }

    let(:request_headers) {
      {
        'Content-Type' => 'application/orcid+xml',
        'Accept' => 'application/xml',
        'Authorization' => "Bearer #{access_token}"
      }
    }

    subject { described_class.new(config) }
    before(:each) do
      stub_request(:post, File.join(config[:host], "v1.1", orcid_profile_id, 'orcid-works/')).
        with(body: payload, headers: request_headers).
        to_return(status: 200)
    end

    context '#call' do
      context 'with valid data' do
        it 'should return the minted orcid' do
          expect(subject.call(orcid_profile_id, payload)).to eq(true)
        end
      end
    end

    context '.call' do
      it 'instantiates and calls underlying instance' do
        expect(described_class.call(orcid_profile_id, payload, config)).to eq(true)
      end
    end

  end
end
