require 'spec_helper'

describe Orcid do
  context '.enqueue' do
    let(:object) { double }

    it 'should #run the object' do
      object.should_receive(:run)
      Orcid.enqueue(object)
    end
  end

  context '.profile_creation_access_token' do
    let(:creation_service) { double('Service') }
    let(:service_response) { { 'access_token' => access_token } }
    let(:access_token) { double('Access Token') }
    it 'should return the access_token' do
      creation_service.should_receive(:call).
        with(scope: '/orcid-profile/create', grant_type:'client_credentials').
        and_return(service_response)
      expect(Orcid.profile_creation_access_token(creation_service: creation_service)).to eq(access_token)
    end
  end
end
