# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    association :user, strategy: :build_stubbed
    provider "twitter"
    uid "1234"
  end
end
