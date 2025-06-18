FactoryBot.define do
  factory :article do
    sequence(:title) { |i| "Sample Article-#{i}" }
    author { "Jane" }
    url { "https://www.viget.com/" }

    trait :published_yesterday do
      created_at { 1.day.ago }
    end
  end
end
