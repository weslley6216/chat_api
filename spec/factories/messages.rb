FactoryBot.define do
  factory :message do
    content { 'Sample content' }
    sender { create(:user) }
    receiver { create(:user) }
    conversation
  end
end
