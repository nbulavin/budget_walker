# frozen_string_literal: true

FactoryBot.define do
  factory :bucket do
    name { 'First Bucket' }

    trait :credit_card do
      type { :credit_card }
    end

    trait :account do
      type { :account }
    end

    trait :saving do
      type { :saving }
    end
  end
end
