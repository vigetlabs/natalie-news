FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test-#{n}@sample.com" }
    sequence(:username) { |n| "test_user_#{n}" }
    password { "password" }
  end
end
