require 'spec_helper'

module Devise::MultiAuth
  describe Authentication do
    let(:attributes) {
      {
        "user_id"=>1,
        "provider"=>"orcid",
        "uid"=>"0000-0002-1117-8571",
        "access_token"=>"4a8e9a1a-e53a-448b-b81d-e541c347a711",
        "refresh_token"=>"b39b89ce-92df-4d99-bd25-309a869d201a"
      }
    }

    context '#to_access_token' do
      let(:client) { double('Client') }
      subject { described_class.new(attributes).to_access_token(client: client) }

      it { should respond_to :get }
      it { should respond_to :post }
      it { should respond_to :refresh! }
      it { should respond_to :expires? }

    end
  end
end
