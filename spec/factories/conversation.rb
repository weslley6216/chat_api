FactoryBot.define do
  factory :conversation do
    transient do
      users { create_list(:user, 2) }
    end

    after(:create) do |conversation, evaluator|
      evaluator.users.each do |user|
        conversation.users << user
      end
    end
  end
end
