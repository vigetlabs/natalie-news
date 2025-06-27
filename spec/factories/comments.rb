FactoryBot.define do
  factory :comment do
    sequence(:body) { |i| "Sample comment-#{i}" }
    association :user
    association :article
  end
end
