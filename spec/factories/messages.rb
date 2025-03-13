FactoryBot.define do
  factory :message do
    content { "Test message content" }
    sender { create(:user) }
    receiver { create(:user) }
  end
end
