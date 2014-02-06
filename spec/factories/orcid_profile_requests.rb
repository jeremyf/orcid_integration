# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :orcid_profile_request, :class => 'Orcid::ProfileRequest' do
    user_id 1
  end
end
