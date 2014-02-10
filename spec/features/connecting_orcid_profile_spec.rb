require 'spec_helper'

describe 'connecting orcid profile', requires_net_connect: true do
  around(:each) do |example|
    WebMock.allow_net_connect!
    example.run
    WebMock.disable_net_connect!
  end

  let(:password) { 'WqtjNG?nA0' }
  # I need a unique email if I am hitting the public ORCID sandbox
  let(:email) { "corwin#{Time.now.strftime('%Y%m%d%H%m%s')}@amber.gov" }

  context 'with a newly created system user' do
    let(:user) { User.where(email: email).first }
    context 'without existing ORCID account' do
      it 'should allow me to create an ORCID account' do
        register_user(email, password)
        create_orcid
      end
    end
    context 'with existing ORCID account' do
      let(:email) { 'jeremy.n.friesen@gmail.com' }
      it 'should allow me to connect to an existing ORCID account' do
        register_user(email, password)
        connect_to_orcid(email)
      end
    end
  end

  def connect_to_orcid(with_email)
    click_on("Connect to my existing ORCID Profile")
    within('form.search-form') do
      
    end
  end

  def register_user(email, password)
    visit new_user_registration_path
    within('form.new_user') do
      fill_in("Email", with: email)
      fill_in("Password", with: password)
      fill_in("Password confirmation", with: password)
      click_on("Sign up")
    end
    expect(page).to have_content('You have signed up successfully.')
  end

  def create_orcid
    click_on("Request ORCID Profile")

    within('form.new_profile_request') do
      fill_in("profile_request[given_names]", with: 'Corwin')
      fill_in("profile_request[family_name]", with: 'Amber')
      fill_in("profile_request[primary_email]", with: email)
      fill_in("profile_request[primary_email_confirmation]", with: email)
      click_on("Create Profile request")
    end

    expect(user.authentications.where(provider: 'orcid').count).to eq(1)
  end
end
