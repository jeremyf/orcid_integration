require 'spec_helper'

describe 'non-UI based interactions' , requires_net_connect: true do
  around(:each) do |example|
    WebMock.allow_net_connect!
    example.run
    WebMock.disable_net_connect!
  end

  context 'issue a profile request' do
    let(:user) { FactoryGirl.create(:user) }

    # Because either ORCID or Mailinator are blocking some emails.
    let(:random_valid_email_prefix) { (0...24).map { (65 + rand(26)).chr }.join.downcase }
    let(:email) {  "#{random_valid_email_prefix}@mailinator.com" }
    let(:profile_request) {
      FactoryGirl.create(:orcid_profile_request, user: user, primary_email: email, primary_email_confirmation: email)
    }

    let(:work) { Orcid::Work.new(title: "Test Driven Orcid Integration", work_type: 'test') }

    before(:each) do
      # Making sure things are properly setup
      expect(profile_request.orcid_profile_id).to be_nil
    end

    it 'creates a profile' do
      profile_request.run

      # We have created an ORCID profile
      orcid_profile_id = profile_request.orcid_profile_id

      expect(orcid_profile_id).to match(/\w{4}-\w{4}-\w{4}-\w{4}/)
    end
  end

  context 'appending a work to an already claimed orcid and authorized' do
    let(:orcid_profile) { Orcid::Profile.new(orcid_profile_id) }
    let(:orcid_profile_id) { ENV['ORCID_CLAIMED_PROFILE_ID']}
    let(:orcid_profile_password) { ENV['ORCID_CLAIMED_PROFILE_PASSWORD']}
    let(:work) { Orcid::Work.new(title: "Test Driven Orcid Integration #23", work_type: 'test') }
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      expect(work).to be_valid

      # I need to authenticate this application against an already claimed
      # ORCID. This is the steps to get to that point
      code = RequestSandboxAuthorizationCode.call(orcid_profile_id: orcid_profile_id, password: orcid_profile_password)
      token = @token = Orcid.oauth_client.auth_code.get_token(code)
      normalized_token = {provider: 'orcid', uid: orcid_profile_id, credentials: {token: token.token, refresh_token: token.refresh_token }}
      CaptureSuccessfulExternalAuthentication.call(user, normalized_token)
    end

    it 'should increment orcid works' do
      user_token = user.authentications.where(provider: 'orcid').first.to_access_token
      expect(Orcid::AppendNewWorkService.call(orcid_profile_id, work.to_xml, token: user_token)).to eq(true)
    end
  end
end
