require 'spec_helper'

describe 'connecting orcid profile' do
  let(:password) { 'WqtjNG?nA0' }
  let(:email) { 'somebody@gmail.com' }
  # Given I have an existing ORCID iD
  # And I have not connected my Account to my ORCID iD
  # When I attempt to authenticate to the Application via ORCID
  # Then I am not authenticated for the Application

  context 'with a newly created system user' do
    it 'should allow me to connect my ORCID account' do
      register_user(email, password)
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
end