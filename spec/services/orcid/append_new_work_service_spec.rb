require 'spec_helper'

module Orcid
  describe AppendNewWorkService do
    let(:payload) { %(<?xml version="1.0" encoding="UTF-8"?>) }
    let(:config) { {token: token, headers: request_headers } }
    let(:token) { double("Token") }
    let(:orcid_profile_id) { '0000-0003-1495-7122' }
    let(:request_headers) { { 'Content-Type' => 'application/orcid+xml', 'Accept' => 'application/xml' } }
    let(:response) { double("Response") }

    subject { described_class.new(config) }

    context '.call' do
      it 'instantiates and calls underlying instance' do
        token.should_receive(:post).
          with("v1.1/#{orcid_profile_id}/orcid-works/", body: payload, headers: request_headers).
          and_return(response)

        expect(described_class.call(orcid_profile_id, payload, config)).to eq(true)
      end
    end

  end
end
