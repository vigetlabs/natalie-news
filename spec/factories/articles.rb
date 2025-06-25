FactoryBot.define do
  factory :article do
    sequence(:title) { |i| "Sample Article-#{i}" }
    url { "https://www.viget.com/" }
    association :user

    trait :published_yesterday do
      created_at { 1.day.ago }
    end
  end
end
