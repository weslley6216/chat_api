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

    trait :with_messages do
      transient do
        messages_count { 1 }
      end

      after(:create) do |conversation, evaluator|
        create_list(:message, evaluator.messages_count, conversation: conversation, sender: conversation.users.first)
      end
    end
  end
end
