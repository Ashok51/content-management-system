FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "User#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }
    country { 'Country' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
  end
end