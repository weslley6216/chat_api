FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "john_doe_#{n}" }
    sequence(:email) { |n| "john#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
