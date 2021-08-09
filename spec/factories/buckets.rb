# frozen_string_literal: true

FactoryBot.define do
  factory :bucket do
    name { 'First Bucket' }

    trait :credit_card do
      bucket_type { :credit_card }
    end

    trait :account do
      bucket_type { :account }
    end

    trait :saving do
      bucket_type { :saving }
    end
  end
end
