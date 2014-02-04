# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    association :user, strategy: :build
    provider "twitter"
    uid "1234"
    token "my_token"
    token_secret "my_secret"
  end
end
