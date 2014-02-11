require 'spec_helper'

describe Orcid do
  context '.configure' do
    it 'should yield a configuration' do
      expect{|b| Orcid.configure(&b) }.to yield_with_args(Orcid::Configuration)
    end
  end
  context '.connect_user_and_orcid_profile' do
    let(:user) { FactoryGirl.build_stubbed(:user) }
    let(:orcid_profile_id) { '0100-0012' }

    it 'changes the authentication count' do
      expect {
        Orcid.connect_user_and_orcid_profile(user, orcid_profile_id)
      }.to change(Authentication.where(provider: 'orcid', user_id: user.id), :count).by(1)
    end
  end

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

  context '.profile_search_access_token' do
    let(:creation_service) { double('Service') }
    let(:service_response) { { 'access_token' => access_token } }
    let(:access_token) { double('Access Token') }
    it 'should return the access_token' do
      creation_service.should_receive(:call).
        with(scope: '/read-public', grant_type:'client_credentials').
        and_return(service_response)
      expect(Orcid.profile_search_access_token(creation_service: creation_service)).to eq(access_token)
    end
  end
end
