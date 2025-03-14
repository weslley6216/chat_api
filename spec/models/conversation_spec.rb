require 'rails_helper'

describe Conversation, type: :model do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user_a).class_name('User').with_foreign_key('user_a_id') }
    it { should belong_to(:user_b).class_name('User').with_foreign_key('user_b_id') }
    it { should have_many(:messages) }
  end
end
