require 'spec_helper'

describe 'non-UI based interactions' , requires_net_connect: true do
  around(:each) do |example|
    WebMock.allow_net_connect!
    example.run
    WebMock.disable_net_connect!
  end
  let(:work) { Orcid::Work.new(title: "Test Driven Orcid Integration", work_type: 'test') }
  let(:user) { FactoryGirl.create(:user) }
  let(:orcid_profile_password) { 'password1A' }

  context 'issue a profile request', api_abusive: true do

    # Because either ORCID or Mailinator are blocking some emails.
    let(:random_valid_email_prefix) { (0...24).map { (65 + rand(26)).chr }.join.downcase }
    let(:email) {  "#{random_valid_email_prefix}@mailinator.com" }
    let(:profile_request) {
      FactoryGirl.create(:orcid_profile_request, user: user, primary_email: email, primary_email_confirmation: email)
    }

    before(:each) do
      # Making sure things are properly setup
      expect(profile_request.orcid_profile_id).to be_nil
    end

    it 'creates a profile' do
      profile_request.run

      orcid_profile_id = profile_request.orcid_profile_id

      expect(orcid_profile_id).to match(/\w{4}-\w{4}-\w{4}-\w{4}/)

      claim_the_orcid!(random_valid_email_prefix)

      authenticate_the_orcid!(orcid_profile_id, orcid_profile_password)

      orcid_profile = Orcid::Profile.new(orcid_profile_id)

      expect(orcid_profile.append_new_work(work)).to eq(true)
    end

  end

  context 'appending a work to an already claimed orcid and authorized', requires_net_connect: true do
    let(:orcid_profile_id) { ENV.fetch('ORCID_CLAIMED_PROFILE_ID')}
    let(:orcid_profile_password) { ENV.fetch('ORCID_CLAIMED_PROFILE_PASSWORD')}

    before(:each) do
      expect(work).to be_valid
      authenticate_the_orcid!(orcid_profile_id, orcid_profile_password)
    end

    subject { Orcid::Profile.new(orcid_profile_id) }
    it 'should increment orcid works' do
      expect(subject.append_new_work(work)).to eq(true)
    end
  end

  # Extract this method as a proper helper
  def authenticate_the_orcid!(orcid_profile_id, orcid_profile_password)
    code = RequestSandboxAuthorizationCode.call(orcid_profile_id: orcid_profile_id, password: orcid_profile_password)
    token = Orcid.oauth_client.auth_code.get_token(code)
    normalized_token = {provider: 'orcid', uid: orcid_profile_id, credentials: {token: token.token, refresh_token: token.refresh_token }}
    CaptureSuccessfulExternalAuthentication.call(user, normalized_token)
  end

  # Achtung, this is going to be fragile
  def claim_the_orcid!(email_prefix)
    Capybara.current_driver = :webkit
    Capybara.app_host = 'http://mailinator.com'
    Capybara.run_server = false

    visit("/inbox.jsp?to=#{email_prefix}")
    sleep(2) # Because mailinator might be slow
    begin
      page.find('#mailcontainer a').click
    rescue Capybara::ElementNotFound => e
      filename = Rails.root.join('tmp/claim_orcid_failure.png')
      page.save_screenshot(filename, full: true)
      `open #{filename}`
      raise e
    end

    sleep(2) # Because mailinator might be slow
    href = page.all('.mailview a').collect { |a| a[:href] }.find {|href| href = /\/claim\//}

    uri = URI.parse(href)
    Capybara.app_host = "#{uri.scheme}://#{uri.host}"

    visit(uri.path)
    page.all('input').each do |input|
      case input[:name]
      when 'password' then input.set(orcid_profile_password)
      when 'confirmPassword' then input.set(orcid_profile_password)
      when 'acceptTermsAndConditions' then input.click
      end
    end
    page.all('button').find {|i| i.text == 'Claim' }.click
    sleep(2) # Because claiming your orcid could be slowe
  end
end
