require 'spec_helper'

describe 'connecting orcid profile' do
  let(:password) { 'WqtjNG?nA0' }
  let(:email) { 'somebody@gmail.com' }
  # Given I have an existing ORCID iD
  # And I have not connected my Account to my ORCID iD
  # When I attempt to authenticate to the Application via ORCID
  # Then I am not authenticated for the Application

  context 'with a newly created system user' do
    let(:user) { User.where(email: email).first }
    xit 'should allow me to create an ORCID account' do
      register_application
      register_user(email, password)
      create_orcid
    end
  end

  def register_application
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
    within('form.new_orcid_profile') do
      click_on("Create ORCID")
    end
    expect(user.authentications.where(profile: 'orcid').count).to eq(1)
  end
end