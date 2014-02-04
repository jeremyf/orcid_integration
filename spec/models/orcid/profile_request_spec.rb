require 'spec_helper'

module Orcid
  describe ProfileRequest do
    context '#call' do
      let(:user) {}
      let(:access_token) {}
      let(:attributes) { {} }
      let(:orcid_profile_id) { '1234-5678' }
      let(:profile_creation_service) { lambda {|*args| orcid_profile_id } }
      subject { Orcid::ProfileRequest.new(user, attributes) }

      xit 'should persist the request so that we do not submit multiple requests' do
      end
      xit 'should use the access_token for profile creation' do
      end
      xit 'should call the profile creation service' do
      end
      xit "should update the request user's authentications" do
      end

    end
  end
end
