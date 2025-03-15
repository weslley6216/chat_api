FactoryBot.define do
  factory :conversation do
    user_a { association :user }
    user_b { association :user }
  end
end
