FactoryBot.define do
  factory :user do
    first_name { 'FirstName' }
    # Use sequence to make sure that the value is unique
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'test' }
    password_confirmation { 'test' }
  end
end
