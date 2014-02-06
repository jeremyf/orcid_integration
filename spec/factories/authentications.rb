# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    association :user, strategy: :build
    provider "twitter"
    uid "1234"
  end
end
