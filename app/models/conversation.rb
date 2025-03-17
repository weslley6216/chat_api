class Conversation < ApplicationRecord
  belongs_to :user_a, class_name: 'User', foreign_key: 'user_a_id'
  belongs_to :user_b, class_name: 'User', foreign_key: 'user_b_id'
  has_many :messages

  def display_name_for(user)
    other_user = (user == user_a) ? user_b : user_a
    other_user.username.capitalize
  end
end
