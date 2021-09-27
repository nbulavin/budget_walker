# frozen_string_literal: true

FactoryBot.define do
  factory :income_category do
    name { 'FirstCategory' }
    expected_revenue { 123 }
  end
end
